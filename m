Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932351Ab3GPMYM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jul 2013 08:24:12 -0400
Received: from mail-oa0-f46.google.com ([209.85.219.46]:52238 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932153Ab3GPMYL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jul 2013 08:24:11 -0400
MIME-Version: 1.0
In-Reply-To: <CAOMZO5D+szAgY6+CHjwFRw2qwvusv2_Ach0hv=hj4X1cmMnHfA@mail.gmail.com>
References: <1373898160-8460-1-git-send-email-otavio@ossystems.com.br>
	<CAOMZO5D+szAgY6+CHjwFRw2qwvusv2_Ach0hv=hj4X1cmMnHfA@mail.gmail.com>
Date: Tue, 16 Jul 2013 09:24:10 -0300
X-Google-Sender-Auth: UVNnQYbZW6figoHK6LRRFKApPaI
Message-ID: <CAP9ODKpByXLm1xkbfxJoktYr2ZNSD1cwNmtV95pfnjQ0jgeWYg@mail.gmail.com>
Subject: Re: [PATCH 1/5] ARM: dts: imx23-evk: enable USB PHY and controller
From: Otavio Salvador <otavio@ossystems.com.br>
To: Fabio Estevam <festevam@gmail.com>
Cc: Jonathan Cameron <jic23@kernel.org>,
        Kernel development list <linux-kernel@vger.kernel.org>,
        Fabio Estevam <fabio.estevam@freescale.com>,
        Shawn Guo <shawn.guo@linaro.org>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 16, 2013 at 12:42 AM, Fabio Estevam <festevam@gmail.com> wrote:
> On Mon, Jul 15, 2013 at 11:22 AM, Otavio Salvador
> <otavio@ossystems.com.br> wrote:
>> The i.MX23EVK board provides a USB port so the USB PHY and controller
>> need to be enabled for it to be usable.
>
> Has this been tested? I don't see in this patch any code to enable USB power.

It does, I am using it.

--
Otavio Salvador                             O.S. Systems
http://www.ossystems.com.br        http://projetos.ossystems.com.br
Mobile: +55 (53) 9981-7854            Mobile: +1 (347) 903-9750
