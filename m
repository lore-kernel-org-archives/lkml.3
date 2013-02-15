Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757153Ab3BOSdk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2013 13:33:40 -0500
Received: from moutng.kundenserver.de ([212.227.17.8]:54874 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756443Ab3BOSdj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2013 13:33:39 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Mark Rutland <mark.rutland@arm.com>
Subject: Re: [PATCH 1/9] ARM: arch_timer: include linux/errno.h
Date: Fri, 15 Feb 2013 18:33:31 +0000
User-Agent: KMail/1.12.2 (Linux/3.8.0-6-generic; KDE/4.3.2; x86_64; ; )
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "arm@kernel.org" <arm@kernel.org>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Marc Zyngier <Marc.Zyngier@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>
References: <1360882071-4072668-1-git-send-email-arnd@arndb.de> <1360882071-4072668-2-git-send-email-arnd@arndb.de> <20130215102618.GJ25537@e106331-lin.cambridge.arm.com>
In-Reply-To: <20130215102618.GJ25537@e106331-lin.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201302151833.31646.arnd@arndb.de>
X-Provags-ID: V02:K0:ctP8iOxZPa9ix0RnvHemHjUh89yB2VuzLAdqhsep1yd
 gsPUl2XuvmtRjwBIe82Hlh2+rEN38IhqT6VA26J7Gt94P/tEqX
 lKJ+6naAz+2n2Fy+pse77TWsa64VFhwBe3SbUlk4DOsyppeeY9
 yAQM3CyBZ89RKZkOQYi1EWVl+fgcygKXHu/cdCQADfOZRzUlSZ
 g7rzl9KdlzC9qpV4BsGBzeYdxuVXYnPgh7RWYmqLsVJ7nOpeFE
 ieUziMH3Ukdrs3xqy41OXE+1hofGiF6HIB1HdJzALYCXERNDnG
 Q+Yew4xdFXfcfu+OvDzdqPYUpCDV2yQUC3wb5d1+62BvlIrYHX
 vj5RYhDWu5jIP+DB/+4A=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 15 February 2013, Mark Rutland wrote:
> As with Stephen Warren's fix [1], this looks right to me. Stephen's has the
> added benefit of keeping the includes ordered.
> 
> For either version:
> 
> Acked-By: Mark Rutland <mark.rutland@arm.com>

Applied to the next/virt branch now.

	Arnd
