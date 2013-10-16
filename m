Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760069Ab3JPHu4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 03:50:56 -0400
Received: from mail-ie0-f171.google.com ([209.85.223.171]:33907 "EHLO
	mail-ie0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753622Ab3JPHuy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 03:50:54 -0400
MIME-Version: 1.0
In-Reply-To: <20131016063947.GD4282@core.coreip.homeip.net>
References: <1381872071-23455-1-git-send-email-linus.walleij@linaro.org>
	<20131016063947.GD4282@core.coreip.homeip.net>
Date: Wed, 16 Oct 2013 09:50:54 +0200
Message-ID: <CACRpkdbjHVGHCuUAjhM6uxtah45PUhedSxzh0gZkjbHot2oeqA@mail.gmail.com>
Subject: Re: [PATCH 4/5] input: tc3589x-keypad: support probing from device tree
From: Linus Walleij <linus.walleij@linaro.org>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Linux Input <linux-input@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 16, 2013 at 8:39 AM, Dmitry Torokhov
<dmitry.torokhov@gmail.com> wrote:
> On Tue, Oct 15, 2013 at 11:21:11PM +0200, Linus Walleij wrote:
>> Implement device tree probing for the tc3589x keypad driver.
>> This is modeled on the STMPE keypad driver and tested on the
>> Ux500 TVK1281618 UIB.
>>
>> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
>
> Looks good, should I merge it or you want to take it through another
> tree??

As this one is only using old device tree bindings
(Documentation/devicetree/bindings/input/matrix-keymap.txt
and friends) I think you can just merge it.

Yours,
Linus Walleij
