Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933269Ab3FRRcB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 13:32:01 -0400
Received: from mail-ve0-f170.google.com ([209.85.128.170]:52614 "EHLO
	mail-ve0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932728Ab3FRRb7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 13:31:59 -0400
MIME-Version: 1.0
X-Originating-IP: [84.115.78.137]
In-Reply-To: <1371514253.9073.8@snotra>
References: <1371241083.2996.7@snotra>
	<2435509.QyTW5GJC53@pcimr>
	<1371514253.9073.8@snotra>
Date: Tue, 18 Jun 2013 19:31:58 +0200
Message-ID: <CALG0vJszdSp+HViLq3hL6BOASGrasHx34AgtUExCS3FoOa4uvw@mail.gmail.com>
Subject: Re: [PATCH v2] powerpc/pci: Fix setup of Freescale PCI / PCIe controllers
From: Michael Guntsche <michael.guntsche@it-loops.com>
To: Scott Wood <scottwood@freescale.com>
Cc: Rojhalat Ibrahim <imr@rtschenk.de>, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 18, 2013 at 2:10 AM, Scott Wood <scottwood@freescale.com> wrote:
> On 06/17/2013 08:15:33 AM, Rojhalat Ibrahim wrote:
>>
>> On Friday 14 June 2013 15:18:03 Scott Wood wrote:
>> > On 83xx:
>> > cc1: warnings being treated as errors
>> > /home/scott/fsl/git/linux/upstream/arch/powerpc/sysdev/fsl_pci.c:100:23:
>> > error: 'fsl_indirect_pcie_ops' defined but not used
>> > make[2]: *** [arch/powerpc/sysdev/fsl_pci.o] Error 1
>> > make[2]: *** Waiting for unfinished jobs....
>> >
>> > I can fix this when applying, but this makes me wonder how you tested
>> > it, given that the whole point is to fix 83xx...  Did you fix this and
>> > then accidentally sent a stale version?
>> >
>> > Also, please be careful that the patch doesn't get line wrapped -- I
>> > had to manually unwrap a couple places.  Use git send-email if you
>> > can't get KMail to cooperate.
>> >
>> > -Scott
>>
>> Sorry about the mess. I'll send a v3.
>> Please note: I don't have an 83xx system. So I can only test if it
>> compiles,
>> which I obviously did not do with the right config.
>
>
> OK, so it looks like it was Michael who ran into the problem on 83xx.
> Michael, could you test the v3 patch that Rojhalat posted?
>
> -Scott

I did a quick check against -rc6 and the system compiles and boots up fine.

/Mike
