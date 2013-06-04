Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759877Ab3FDHFY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 03:05:24 -0400
Received: from mail-we0-f176.google.com ([74.125.82.176]:54182 "EHLO
	mail-we0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759833Ab3FDHFV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 03:05:21 -0400
MIME-Version: 1.0
In-Reply-To: <1364816016-29656-1-git-send-email-prabhakar.csengg@gmail.com>
References: <1364816016-29656-1-git-send-email-prabhakar.csengg@gmail.com>
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
Date: Tue, 4 Jun 2013 12:35:00 +0530
Message-ID: <CA+V-a8viYYncvPZ8+qUQ3d87cMKnYz9b1101OoX1KSd_13BrBg@mail.gmail.com>
Subject: Re: [PATCH] ARM: daVinci: remove __init modifier from function declaration
To: Sekhar Nori <nsekhar@ti.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Heiko Schocher <hs@denx.de>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Matt Porter <mporter@ti.com>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Lad, Prabhakar" <prabhakar.csengg@gmail.com>,
        DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        LAK <linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sekhar,

On Mon, Apr 1, 2013 at 5:03 PM, Prabhakar lad
<prabhakar.csengg@gmail.com> wrote:
> From: Lad, Prabhakar <prabhakar.csengg@gmail.com>
>
> This patch removes the __init modifier from function declaration
> of all the header files for davinci platform.
>
gentle ping for v3.11

Regards,
--Prabhakar Lad
