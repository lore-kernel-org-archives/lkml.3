Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932794AbaD2AE4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 20:04:56 -0400
Received: from know-smtprelay-omc-8.server.virginmedia.net ([80.0.253.72]:54219
	"EHLO know-smtprelay-omc-8.server.virginmedia.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932475AbaD2AEz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 20:04:55 -0400
X-Originating-IP: [81.106.150.188]
X-Spam: 0
X-Authority: v=2.1 cv=TM7LSjVa c=1 sm=1 tr=0 a=DGj713NdaxKrsjjgQne7PA==:117
 a=DGj713NdaxKrsjjgQne7PA==:17 a=J0QyKEt1u0cA:10 a=BdtlclQ1lucA:10
 a=uObrxnre4hsA:10 a=IkcTkHD0fZMA:10 a=NLZqzBF-AAAA:8 a=zd2uoN0lAAAA:8
 a=rB7i5J72bpEGVivGSTQA:9 a=QEXdDO2ut3YA:10 a=wu_e27o_rKQA:10
Date: Tue, 29 Apr 2014 01:04:51 +0100
From: Ken Moffat <zarniwhoop@ntlworld.com>
To: Alex Deucher <alexdeucher@gmail.com>
Cc: Ed Tomlinson <edt@aei.ca>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: 3.15.0-rc2 radeon HD 7480D [Aruba] blank display
Message-ID: <20140429000451.GA17008@milliways>
References: <20140421203207.GA27025@milliways>
 <5549363.XIKIYZeGzc@grover>
 <20140422023106.GA1709@milliways>
 <20140422023410.GB1709@milliways>
 <CADnq5_OPQdict2MoUFDcLB0AXjkg9Np4W+U6O+RR8mExWKt-Rw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CADnq5_OPQdict2MoUFDcLB0AXjkg9Np4W+U6O+RR8mExWKt-Rw@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 22, 2014 at 01:54:01AM -0400, Alex Deucher wrote:
> 
> The attached patch should fix it.
> 
> Thanks,
> 
> Alex

> From 9cd764fd57bb2a4e5f618d0f8a64c8154a820688 Mon Sep 17 00:00:00 2001
> From: Alex Deucher <alexander.deucher@amd.com>
> Date: Tue, 22 Apr 2014 01:49:28 -0400
> Subject: [PATCH] drm/radeon/aux: fix hpd assignment for aux bus
> 
 Sorry, my default mailbox (the one where personal mail ends up)
overflowed (the old "procmail thinks it cannot write to it" issue)
and I've been reading mail on my netbook with a short 24-line term,
didn't notice that my overflow mailbox had appeared because it was
on the next screen.  So, sorry for not replying.

 And then when I did notice, I accidentally sent a personal reply
only to Ed.

 The good news is that -rc3 obviously has the fix, and is working
fine.  Thanks.

ĸen
-- 
das eine Mal als Tragödie, dieses Mal als Farce
