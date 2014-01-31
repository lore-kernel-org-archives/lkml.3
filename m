Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932954AbaAaSOh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jan 2014 13:14:37 -0500
Received: from na3sys009aog107.obsmtp.com ([74.125.149.197]:45298 "HELO
	na3sys009aog107.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S932331AbaAaSOg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jan 2014 13:14:36 -0500
X-Greylist: delayed 390 seconds by postgrey-1.27 at vger.kernel.org; Fri, 31 Jan 2014 13:14:35 EST
MIME-Version: 1.0
In-Reply-To: <20140131023307.GD19871@glanzmann.de>
References: <20140130204424.GB19093@glanzmann.de> <CAEP_g=-rshMcq6spFZQJMMA77bgtsETO56CfH0uY26qgAm1fdw@mail.gmail.com>
 <20140131023307.GD19871@glanzmann.de>
From: Jesse Gross <jesse@nicira.com>
Date: Fri, 31 Jan 2014 10:07:40 -0800
Message-ID: <CAEP_g=8nzs+bRwoF99akReFO46SFa4KJ9Bw=UL0LpwbqwHvO+w@mail.gmail.com>
Subject: Re: [ovs-discuss] Linus GIT Head OOPs reproducable in open vswitch
 when running mininet topology
To: Thomas Glanzmann <thomas@glanzmann.de>, Jesse Gross <jesse@nicira.com>,
        "discuss@openvswitch.org" <discuss@openvswitch.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 30, 2014 at 6:33 PM, Thomas Glanzmann <thomas@glanzmann.de> wrote:
> Hello Jesse,
>
>> This looks like the kernel module included with upstream Linux instead
>> of from OVS git, is that correct?
>
> coorect.
>
>> Can you please describe what you are doing instead of just giving your script?
>
> I created 8 hosts. 2 hosts are connected two each switches. That gives
> me 4 switches which are connected using a ring topology. The reason for
> that is that I want to test the Layer2, Layer3 IPv4 and IPv6
> capabilities of OpenDayLight.

Do you know what type of devices are being attached to OVS (i.e. tap,
veth, etc.)?

Do you know if this happens with an older kernel or with a simpler topology?
