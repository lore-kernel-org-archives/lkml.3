Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753604AbbATKLA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 05:11:00 -0500
Received: from mail-ig0-f178.google.com ([209.85.213.178]:53299 "EHLO
	mail-ig0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752916AbbATKK6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 05:10:58 -0500
MIME-Version: 1.0
In-Reply-To: <1421666844-14599-1-git-send-email-ricardo.ribalda@gmail.com>
References: <20150119105753.GC21553@leverpostej>
	<1421666844-14599-1-git-send-email-ricardo.ribalda@gmail.com>
Date: Tue, 20 Jan 2015 11:10:58 +0100
Message-ID: <CACRpkdZm7k+VCScU_Th_J5oA4gv_tCgRvvvC+9ZHLzxVbCogdQ@mail.gmail.com>
Subject: Re: [PATCH v2 4/8] gpio-mm-lantiq: Use of_property_read_u32
From: Linus Walleij <linus.walleij@linaro.org>
To: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Cc: "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Alexandre Courbot <gnurou@gmail.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, John Crispin <blogic@openwrt.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Mark Rutland <mark.rutland@arm.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 19, 2015 at 12:27 PM, Ricardo Ribalda Delgado
<ricardo.ribalda@gmail.com> wrote:

> Instead of parsing manually the shadow content, use the much simpler
> helper of_property_read_u32.
>
> Cc: Linus Walleij <linus.walleij@linaro.org>
> Cc: Alexandre Courbot <gnurou@gmail.com>
> Cc: Grant Likely <grant.likely@linaro.org>
> Cc: Rob Herring <robh+dt@kernel.org>
> Cc: John Crispin <blogic@openwrt.org>
> Cc: devicetree@vger.kernel.org
> Cc: Mark Rutland <mark.rutland@arm.com>
> Signed-off-by: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
> ---
>
> v2: Reported by Mark Rutland <mark.rutland@arm.com>
>  -use of_property_read_u32 instead of u16

This v2 version applied.

Yours,
Linus Walleij
