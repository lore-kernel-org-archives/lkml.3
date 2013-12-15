Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754284Ab3LOMsx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Dec 2013 07:48:53 -0500
Received: from nm45-vm8.bullet.mail.bf1.yahoo.com ([216.109.115.79]:28208 "HELO
	nm45-vm8.bullet.mail.bf1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753982Ab3LOMsv convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Dec 2013 07:48:51 -0500
X-Greylist: delayed 360 seconds by postgrey-1.27 at vger.kernel.org; Sun, 15 Dec 2013 07:48:51 EST
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 53223.33270.bm@omp1049.mail.bf1.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:X-Rocket-MIMEInfo:X-Mailer:References:Message-ID:Date:From:Reply-To:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=PusQv5gflnEBTlY5XiYK4p6rtfXMHSJS9FvDzCbDE7yfkzhjI/nuIuC9gr2YMGHp7rxdQIcxwHHN0S1uDdAZcOpvWOUeWN1aUf3AS9Mg0GdBfhsvA+cup79/wTzWivFEpLq79OcmbbL0mMSnN41VxJ2mqBrgZMoE8rus0JKXAWc=;
X-YMail-OSG: p4ggC1MVM1lq7PKqVPrg4KuT_6BtpxVPDm0Wq2Cvo7mrRB6
 9nqZ5iTWiN4Gg7n5PSedzqwJRN5pY.N4EkoMN53f4JP9ZiCoj9mSn0d14OIy
 VBPDYJEjuPHt6M2OvHkief2PbfczVUoeJkeUrHZSFzLKTgfBJj1N5ffSMjwi
 SX8zRuYKWhe9u.oBOIJ8jZqpryjkcc6X6xAXvfm3pxHP1XLQzOS19R1Gu1Ks
 0RbmJ1zE_w7KhzzHWAGmAVV94E5X0Td5PEpkUStKYBW4GYNUtvS_UBBKjDFd
 q24WfE8Gh6nDTYhB6gwFOu_E04RsfEiKHjFckugD18mmFt6ve81WXnsW.KQy
 Dqlpx6TzXsKkPetrYWkN_lX0yNv2McY5IX_gEH88cBDC2z_bFxOCXkh4_gS9
 5deVxL9hKaWFVU7ML.XjQmC.s58__JQm6hnYSRdDYFStF__HJbO8I0ezCU2W
 EqxDPThItSYVbRxObQbMhEWwrfY0y9ZYr4caoKBLLeFgQP533zH2PslHvh.m
 P_idu.nxb1WG5sKF_6uzwOarvaOzRuuhEGIVLXr9l3f76svt3l0WL6RfbZY0
 iA5zuHnKq7v.jtyo.lHA-
X-Rocket-MIMEInfo: 002.001,CgoKCi0tLS0tIE9yaWdpbmFsIE1lc3NhZ2UgLS0tLS0KPiBGcm9tOiBSaWNoYXJkIFdlaW5iZXJnZXIgPD4KPgo.IEEgKnZlcnkqIHNtYWxsIHNwZWVkdXAuCj4gCj4gQW5kIEkgcmVhbGx5IGRvdWJ0IHlvdXIgbnVtYmVycy4KPiBXaHkgYXJlIHlvdSB1c2luZyBBTk9WQT8gWW91J3JlIGNvbXBhcmluZyAqdHdvKiBncm91cHMgbm90IG1vcmUgdGhhbiB0d28uCj4gSSBoYWQgYSBxdWljayBsb29rIGF0IHlvdXIgcmF3IG51bWJlcnMsIHRoZXkgZG9uJ3Qgc2VlbSB0byBiZSBub3JtYWxseQo.IGRpc3RyaWJ1dGUBMAEBAQE-
X-Mailer: YahooMailWebService/0.8.169.609
References: <1386518000.90452.YahooMailNeo@web140004.mail.bf1.yahoo.com>	<864985fbeb1d8148439e25ec01f47a67@ixit.cz>	<52AAFF89.5080509@gmail.com>	<1387051250.86178.YahooMailNeo@web140005.mail.bf1.yahoo.com>	<ce679ca5-bf83-4c2a-9234-859cc7a4206b@email.android.com>	<1387057337.97000.YahooMailNeo@web140004.mail.bf1.yahoo.com>	<52ACECC4.208@zytor.com>	<1387108841.76039.YahooMailNeo@web140006.mail.bf1.yahoo.com> <CAFLxGvxakZS5FFQcZ_ogTd9aUENT3ECj2Lxs+FCbZAiGqgOJ7g@mail.gmail.com>
Message-ID: <1387111370.81380.YahooMailNeo@web140001.mail.bf1.yahoo.com>
Date: Sun, 15 Dec 2013 04:42:50 -0800 (PST)
From: John <da_audiophile@yahoo.com>
Reply-To: John <da_audiophile@yahoo.com>
Subject: Re: [PATCH] expand micro-optimizations in kernel to newer model CPUs
To: Richard Weinberger <richard.weinberger@gmail.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "david.heidelberger@ixit.cz" <david.heidelberger@ixit.cz>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "x86@kernel.org" <x86@kernel.org>, lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <CAFLxGvxakZS5FFQcZ_ogTd9aUENT3ECj2Lxs+FCbZAiGqgOJ7g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org





----- Original Message -----
> From: Richard Weinberger <>
>
> A *very* small speedup.
> 
> And I really doubt your numbers.
> Why are you using ANOVA? You're comparing *two* groups not more than two.
> I had a quick look at your raw numbers, they don't seem to be normally
> distributed at all.
> Did you remove some peaks?
> 


Hi Richard.  Thank you for your interest.  Yes, a small speedup as I mentioned but  I'll note that the current kernel code includes the MCORE2 option.  I tested this against some of the newer ones and they are all on par with each other.  For example, here are differences in median values:

CPUDifference in median value
core2        +87.5 ms
core7-avx+79.7 ms
core-avx-i+257.2 ms

I am using ANOVA to establish that the generic group differs from the optimized group.  I have always used ANOVA for this sort of comparison whether using two or more groups.  In fact, thumb through any medical or scientific journal, you'll see others in pier reviewed article doing the same.  

I did not remove any datapoints; I do not understand why you don't think the sets are normally distributed.  Did you see the normal quantile plots?  Additionally, the population variances are fairly equal (Levene and Barlett tests). 
