Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932140AbaAaCdL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jan 2014 21:33:11 -0500
Received: from infra.glanzmann.de ([88.198.249.254]:47715 "EHLO
	infra.glanzmann.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753635AbaAaCdJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jan 2014 21:33:09 -0500
Date: Fri, 31 Jan 2014 03:33:07 +0100
From: Thomas Glanzmann <thomas@glanzmann.de>
To: Jesse Gross <jesse@nicira.com>
Cc: "discuss@openvswitch.org" <discuss@openvswitch.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [ovs-discuss] Linus GIT Head OOPs reproducable in open vswitch
 when running mininet topology
Message-ID: <20140131023307.GD19871@glanzmann.de>
Mail-Followup-To: Thomas Glanzmann <thomas@glanzmann.de>,
	Jesse Gross <jesse@nicira.com>,
	"discuss@openvswitch.org" <discuss@openvswitch.org>,
	LKML <linux-kernel@vger.kernel.org>
References: <20140130204424.GB19093@glanzmann.de>
 <CAEP_g=-rshMcq6spFZQJMMA77bgtsETO56CfH0uY26qgAm1fdw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEP_g=-rshMcq6spFZQJMMA77bgtsETO56CfH0uY26qgAm1fdw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Jesse,

> This looks like the kernel module included with upstream Linux instead
> of from OVS git, is that correct?

coorect.

> Can you please describe what you are doing instead of just giving your script?

I created 8 hosts. 2 hosts are connected two each switches. That gives
me 4 switches which are connected using a ring topology. The reason for
that is that I want to test the Layer2, Layer3 IPv4 and IPv6
capabilities of OpenDayLight.

Cheers,
        Thomas
