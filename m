Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967713Ab3DRKMU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Apr 2013 06:12:20 -0400
Received: from 7.mo3.mail-out.ovh.net ([46.105.57.200]:48137 "EHLO
	mo3.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S967693Ab3DRKMS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Apr 2013 06:12:18 -0400
X-Greylist: delayed 368 seconds by postgrey-1.27 at vger.kernel.org; Thu, 18 Apr 2013 06:12:18 EDT
Date: Thu, 18 Apr 2013 12:01:32 +0200
From: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
To: Pranavkumar Sawargaonkar <pranavkumar@linaro.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>, linaro-kernel@lists.linaro.org,
        Anup Patel <anup.patel@linaro.org>, patches@linaro.org,
        linux-kernel@vger.kernel.org,
        "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>,
        linux-arm-kernel@lists.infradead.org
X-Ovh-Mailout: 178.32.228.3 (mo3.mail-out.ovh.net)
Subject: Re: [RFC] arm64: Early printk support for virtio-mmio console
 devices.
Message-ID: <20130418100132.GE4998@game.jcrosoft.org>
References: <1366264344-28025-1-git-send-email-pranavkumar@linaro.org>
 <87wqs02uws.fsf@rustcorp.com.au>
 <CAAHg+HiHKV+8hBT1QWe4hSxocCX6wpRd3bCPWB7zU8jVFmPuAA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAAHg+HiHKV+8hBT1QWe4hSxocCX6wpRd3bCPWB7zU8jVFmPuAA@mail.gmail.com>
X-PGP-Key: http://uboot.jcrosoft.org/plagnioj.asc
X-PGP-key-fingerprint: 6309 2BBA 16C8 3A07 1772 CC24 DEFC FFA3 279C CE7C
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Ovh-Tracer-Id: 14234752523969800996
X-Ovh-Remote: 213.251.161.87 (ns32433.ovh.net)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeifedrvdehucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeifedrvdehucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 13:02 Thu 18 Apr     , Pranavkumar Sawargaonkar wrote:
> On 18 April 2013 12:21, Rusty Russell <rusty@rustcorp.com.au> wrote:
> >
> > PranavkumarSawargaonkar <pranavkumar@linaro.org> writes:
> > > From: Pranavkumar Sawargaonkar <pranavkumar@linaro.org>
> > >
> > > This patch implements early printk support for virtio-mmio console devices without using any hypercalls.
> >
> > This makes some sense, though not sure that early console *read* makes
> > much sense.  I can see the PCI version of this being useful as well.
> 
> Read can be useful for "mach-virt" which will have only virtio console
> as a console device. Then if someone wants to have UEFI or any other
> boot-loader emulation, which expects user to input few things, in that
> case read might become handy.

yes I'm adding barebox on arm64 and will need it for virt target

Best Regards,
J.
> >
> >
> > The spec definition for this will be interesting, because it can be used
> > before the device is initialized (something which is generally
> > verboten).
> >
> > Cheers,
> > Rusty.
> 
> Thanks,
> Pranav
> 
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
