Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753615AbbATKPg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 05:15:36 -0500
Received: from mail-ie0-f178.google.com ([209.85.223.178]:36611 "EHLO
	mail-ie0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753237AbbATKPd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 05:15:33 -0500
MIME-Version: 1.0
In-Reply-To: <1421581173-28416-8-git-send-email-ricardo.ribalda@gmail.com>
References: <1421581173-28416-1-git-send-email-ricardo.ribalda@gmail.com>
	<1421581173-28416-8-git-send-email-ricardo.ribalda@gmail.com>
Date: Tue, 20 Jan 2015 11:15:30 +0100
Message-ID: <CACRpkdY074juk8MYLVY_--vfdFkB7dsaMCBSa-ynADQ8qGt4jQ@mail.gmail.com>
Subject: Re: [PATCH 7/8] gpio/mpc8xxx: Convert to platform device interface.
From: Linus Walleij <linus.walleij@linaro.org>
To: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Cc: "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Alexandre Courbot <gnurou@gmail.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, Peter Korsgaard <jacmet@sunsite.dk>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 18, 2015 at 12:39 PM, Ricardo Ribalda Delgado
<ricardo.ribalda@gmail.com> wrote:

> This way we do not need to transverse the device tree manually.
>
> Cc: Linus Walleij <linus.walleij@linaro.org>
> Cc: Alexandre Courbot <gnurou@gmail.com>
> Cc: Grant Likely <grant.likely@linaro.org>
> Cc: Rob Herring <robh+dt@kernel.org>
> Cc: Peter Korsgaard <jacmet@sunsite.dk>
> Cc: devicetree@vger.kernel.org
> Signed-off-by: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>

Patch applied with the ACKs, hope nothing explodes.

Yours,
Linus Walleij
