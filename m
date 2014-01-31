Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753605AbaAaBhr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jan 2014 20:37:47 -0500
Received: from na3sys009aog126.obsmtp.com ([74.125.149.155]:57302 "HELO
	na3sys009aog126.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752302AbaAaBhq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jan 2014 20:37:46 -0500
MIME-Version: 1.0
In-Reply-To: <20140130204424.GB19093@glanzmann.de>
References: <20140130204424.GB19093@glanzmann.de>
From: Jesse Gross <jesse@nicira.com>
Date: Thu, 30 Jan 2014 17:37:25 -0800
Message-ID: <CAEP_g=-rshMcq6spFZQJMMA77bgtsETO56CfH0uY26qgAm1fdw@mail.gmail.com>
Subject: Re: [ovs-discuss] Linus GIT Head OOPs reproducable in open vswitch
 when running mininet topology
To: Thomas Glanzmann <thomas@glanzmann.de>,
        "discuss@openvswitch.org" <discuss@openvswitch.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 30, 2014 at 12:44 PM, Thomas Glanzmann <thomas@glanzmann.de> wrote:
> Hello,
> open vswitch git head with Linus tip OOPses for me reproducable when I
> load the following mininet topology:

This looks like the kernel module included with upstream Linux instead
of from OVS git, is that correct?

Can you please describe what you are doing instead of just giving your script?

It would also be helpful if you could use GDB to find out the source
of the faulting address.
