Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752849Ab3CUUHo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 16:07:44 -0400
Received: from mail-ia0-f170.google.com ([209.85.210.170]:46688 "EHLO
	mail-ia0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752695Ab3CUUHk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 16:07:40 -0400
MIME-Version: 1.0
In-Reply-To: <1363870366.3312.1.camel@pasglop>
References: <1363865097-32764-1-git-send-email-grant.likely@secretlab.ca>
 <1363865097-32764-3-git-send-email-grant.likely@secretlab.ca> <1363870366.3312.1.camel@pasglop>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Thu, 21 Mar 2013 20:07:18 +0000
X-Google-Sender-Auth: EVc6Oawaj9jmmHKjrrgVeokf858
Message-ID: <CACxGe6vSywW_iekAKmDMf5_TLLt5Hn+Jttq8kddq3vJ=AE+DQA@mail.gmail.com>
Subject: Re: [PATCH V2 2/2] of: remove /proc/device-tree
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        devicetree-discuss <devicetree-discuss@lists.ozlabs.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        David Miller <davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 21, 2013 at 12:52 PM, Benjamin Herrenschmidt
<benh@kernel.crashing.org> wrote:
> On Thu, 2013-03-21 at 11:24 +0000, Grant Likely wrote:
>> The same data is now available in sysfs, so we can remove the code
>> that exports it in /proc and replace it with a symlink to the sysfs
>> version.
>>
>> Tested on versatile qemu model and mpc5200 eval board. More testing
>> would be appreciated.
>
> This should be delayed until we are 100% confident that the sysfs
> variant is totally backward compatible with anything that messes around
> with /proc/device-tree.

Yup, I agree with that.

> kexec comes to mind (all 4 variants of fs2dt.c (yuck !)), dtc, various
> powerpc-utils (bootloader configuration etc...), and more.
>
> We also need to test the new code with hotplug, I'll see if I can get
> somebody at IBM to give it a spin.

Thanks

g.
