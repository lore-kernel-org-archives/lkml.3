Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932499AbbA2DwA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 22:52:00 -0500
Received: from mail-wi0-f173.google.com ([209.85.212.173]:43365 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752716AbbA2BRX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 20:17:23 -0500
MIME-Version: 1.0
In-Reply-To: <20150128193247.GH2570@ti.com>
References: <1422260488-380-1-git-send-email-prabhakar.csengg@gmail.com> <20150128193247.GH2570@ti.com>
From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Date: Wed, 28 Jan 2015 21:01:04 +0000
Message-ID: <CA+V-a8vC3Pt+hwYr_3oOgq9DN5NUb=Dh0vWKs9KpsccmSz6TGw@mail.gmail.com>
Subject: Re: [PATCH v3] ARM: AM43xx: hwmod: add VPFE hwmod entries
To: Benoit Parrot <bparrot@ti.com>
Cc: Paul Walmsley <paul@pwsan.com>, Tony Lindgren <tony@atomide.com>,
        LAK <linux-arm-kernel@lists.infradead.org>,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Darren Etheridge <detheridge@ti.com>, Felipe Balbi <balbi@ti.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Benoit,

On Wed, Jan 28, 2015 at 7:32 PM, Benoit Parrot <bparrot@ti.com> wrote:
> Suspend/resume is functional with this patch.
>
> Tested-by: Benoit Parrot <bparrot@ti.com>
>
Thanks for the test, I was facing issues with loading the pm firmware.

Cheers,
--Prabhakar Lad
