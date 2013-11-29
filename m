Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753203Ab3K2JZW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Nov 2013 04:25:22 -0500
Received: from mail-ob0-f180.google.com ([209.85.214.180]:39208 "EHLO
	mail-ob0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751440Ab3K2JZR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Nov 2013 04:25:17 -0500
MIME-Version: 1.0
In-Reply-To: <1385494815-15740-6-git-send-email-grygorii.strashko@ti.com>
References: <1385494815-15740-1-git-send-email-grygorii.strashko@ti.com>
	<1385494815-15740-6-git-send-email-grygorii.strashko@ti.com>
Date: Fri, 29 Nov 2013 10:25:14 +0100
Message-ID: <CACRpkda=5KyvRpN=O5UHhX8S-jYB-0g3272Xg61_jvpCEb7Nzg@mail.gmail.com>
Subject: Re: [RFC v1 5/9] gpio: davinci: reuse for Keystone SoC
From: Linus Walleij <linus.walleij@linaro.org>
To: Grygorii Strashko <grygorii.strashko@ti.com>
Cc: Santosh Shilimkar <santosh.shilimkar@ti.com>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "Nori, Sekhar" <nsekhar@ti.com>,
        Prabhakar Lad <prabhakar.csengg@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "davinci-linux-open-source@linux.davincidsp.com" 
	<davinci-linux-open-source@linux.davincidsp.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 26, 2013 at 8:40 PM, Grygorii Strashko
<grygorii.strashko@ti.com> wrote:

> The similar GPIO HW block is used by keystone SoCs as
> in Davinci SoCs.
> Hence, reuse Davinci GPIO driver for Keystone.
>
> Documentation:
>  http://www.ti.com/lit/ug/sprugv1/sprugv1.pdf
>
> Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>

This is really nice, and we want to reuse stuff.

Just waiting for some comments on the previous patch...

Yours,
Linus Walleij
