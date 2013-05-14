Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756635Ab3ENJHQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 May 2013 05:07:16 -0400
Received: from mail-ia0-f174.google.com ([209.85.210.174]:63549 "EHLO
	mail-ia0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752778Ab3ENJHP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 May 2013 05:07:15 -0400
MIME-Version: 1.0
In-Reply-To: <1368207956-32220-1-git-send-email-linux@prisktech.co.nz>
References: <1368207956-32220-1-git-send-email-linux@prisktech.co.nz>
Date: Tue, 14 May 2013 11:07:14 +0200
Message-ID: <CACRpkdZC4RC-OnGJYNooRRoc7q5d1x8PH26+cnwBHw8ppzynEg@mail.gmail.com>
Subject: Re: [PATCH] pinctrl: vt8500: Fix incorrect data in WM8750 pinctrl table
From: Linus Walleij <linus.walleij@linaro.org>
To: Tony Prisk <linux@prisktech.co.nz>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "vt8500-wm8505-linux-kernel@googlegroups.com" 
	<vt8500-wm8505-linux-kernel@googlegroups.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 10, 2013 at 7:45 PM, Tony Prisk <linux@prisktech.co.nz> wrote:

> WMT_PIN_WAKEUP1 should be declared as WMT_PIN(0, 17) rather than
> WMT_PIN(0, 16). This currently generates a runtime warning because
> WMT_PIN_WAKEUP0 is already defined as WMT_PIN(0, 16).
>
> Signed-off-by: Tony Prisk <linux@prisktech.co.nz>

Applied to my fixes branch.

Yours,
Linus Walleij
