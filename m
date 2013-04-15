Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755210Ab3DOUcV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Apr 2013 16:32:21 -0400
Received: from mail-ie0-f169.google.com ([209.85.223.169]:52750 "EHLO
	mail-ie0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751541Ab3DOUcU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Apr 2013 16:32:20 -0400
MIME-Version: 1.0
In-Reply-To: <20130415202934.GB25053@quad.lixom.net>
References: <1365523198.12439.1.camel@phoenix>
	<51646C5C.7080108@prisktech.co.nz>
	<20130415202934.GB25053@quad.lixom.net>
Date: Mon, 15 Apr 2013 22:32:18 +0200
Message-ID: <CACRpkdb3kzGXhACabX57QZfHXt8nx4D0vzJoOsz+VoU8_auybQ@mail.gmail.com>
Subject: Re: [PATCH] pinctrl: vt8500: wmt: Fix checking return value of pinctrl_register()
From: Linus Walleij <linus.walleij@linaro.org>
To: Olof Johansson <olof@lixom.net>
Cc: Tony Prisk <linux@prisktech.co.nz>, Axel Lin <axel.lin@ingics.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 15, 2013 at 10:29 PM, Olof Johansson <olof@lixom.net> wrote:
> On Wed, Apr 10, 2013 at 07:30:36AM +1200, Tony Prisk wrote:
>> Linus,
>> If you're happy with this patch, I'll forward it on to arm-soc to go
>> in with the rest.
>
> I was asked to apply this directly, and have done so (to next/drivers).

That's cool,
Acked-by.

Yours,
Linus Walleij
