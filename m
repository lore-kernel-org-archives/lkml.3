Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753638Ab3EHIyu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 May 2013 04:54:50 -0400
Received: from mail-la0-f41.google.com ([209.85.215.41]:32857 "EHLO
	mail-la0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751557Ab3EHIyq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 May 2013 04:54:46 -0400
MIME-Version: 1.0
In-Reply-To: <1786821921.88859.1368002273356.JavaMail.mail@webmail05>
References: <CAErSpo7qj2SNR7BfuBsfF-saZXvgcqqLtgoP5Hyb5u99qR4Ncg@mail.gmail.com>
	<Pine.LNX.4.44L0.1302191119270.2215-100000@iolanthe.rowland.org>
	<CAErSpo7NZoOQZyW76HEoOTVgdqL2CgbVScAeF6HGLAVaNCq0=w@mail.gmail.com>
	<337833384.57445.1361860509194.JavaMail.mail@webmail08>
	<CAErSpo6CbO5KYXiErv6J_Dnm1u694C5fQPP2_cZL8VKDEnZa9A@mail.gmail.com>
	<569718148.80620.1361906088301.JavaMail.mail@webmail13>
	<CAErSpo6UkVhSf+nFW4zwJLBQw_0RQ5H9Bv-UuQRb6zdwsFPw4g@mail.gmail.com>
	<CAErSpo4X+XXKvWDfqh2CKZAtJ9WMQk91OcsWwdxwYv2MfEM_zQ@mail.gmail.com>
	<771333906.75854.1367057440028.JavaMail.mail@webmail08>
	<CAErSpo4B4sRco-nuqgXiYtGQxBcbEB6ArQjHD0A9cj4TRE+qQw@mail.gmail.com>
	<518097B8.4020402@gmail.com>
	<CAErSpo7KWPRVEnw+n068pUZz+=WSTwno6m6t7N6dunuhnFC8EA@mail.gmail.com>
	<384171828.66802.1367942365492.JavaMail.mail@webmail05>
	<CADLC3L3bdTP8-X3ftMq1qxnL=LVDf7d5gbu2ZMH0pXg2AU8xjw@mail.gmail.com>
	<CAErSpo50iyEbCer+-K8uXUdnsG_EzFe_ZjKnrtfq5x0Zw3Yd6w@mail.gmail.com>
	<CAMeQTsZEpRE_bv6o9mBpqNrbf36SZVscxy+JS72=BOzA1ey-XQ@mail.gmail.com>
	<CAErSpo75SETEe-OKhY2-NW3csaxt=f09JcheHx95bzkCcGO6yg@mail.gmail.com>
	<CAMeQTsY1jc99boFC_KDTL=-Pt-W1q5ZiS+r89QkPE+vAk386UQ@mail.gmail.com>
	<1786821921.88859.1368002273356.JavaMail.mail@webmail05>
Date: Wed, 8 May 2013 10:54:44 +0200
Message-ID: <CAMeQTsY4gupzL2g-10n9wSMzpxNKp-xNKOOcYiNm0d+5jq5Xyw@mail.gmail.com>
Subject: Re: Abysmal HDD/USB write speed after sleep on a UEFI system
From: Patrik Jakobsson <patrik.r.jakobsson@gmail.com>
To: "Artem S. Tashkinov" <t.artem@lycos.com>
Cc: bhelgaas@google.com, hancockrwd@gmail.com, stern@rowland.harvard.edu,
        torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org, rjw@sisk.pl, psusi@ubuntu.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 8, 2013 at 10:37 AM, Artem S. Tashkinov <t.artem@lycos.com> wrote:
>>I think this is the official statement from Intel on the SATA issue:
>>http://newsroom.intel.com/community/intel_newsroom/blog/2011/01/31/intel-identifies-chipset-design-error-implementing-solution
>
> My motherboard has a new fixed B3 revision so this issue doesn't affect me.
> Besides this SATA ports degradation issue is constantly present - it has no
> relationship to suspend.

Yes, Rev. B3 should be fine.

>>And here's a link to a discussion about the PCIe-to-PCI bridge stuff:
>>https://lkml.org/lkml/2012/1/30/216
>>
>>> Artem's system has a PCIe-to-PCI bridge (not a PCI-to-PCIe bridge) at
>>> 05:00.0, but it leads to [bus 06] and there's nothing on bus 06, so I
>>> don't think that's the problem.
>>
>>I meant what you said ;) and yes, it seems unrelated. Both my P8H67 and a
>>P8P67 I've built behave nicely if nothing is connected.
>
> Have you tried suspending more than three times? In the absence of UEFI
> boot this bug emerges only on a third or even fourth resume attempt. UEFI
> boot triggers it immediately on a first resume though.

I haven't enabled UEFI boot but did ~10 suspend/resume cycles with no issues.
I'm on 3.9-rc5 if that makes a difference. I'll do some more testing with
various kernel versions to see if I can trigger it.

-Patrik
