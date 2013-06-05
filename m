Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753002Ab3FEJV6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 05:21:58 -0400
Received: from mail-wg0-f46.google.com ([74.125.82.46]:53312 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751819Ab3FEJV4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 05:21:56 -0400
MIME-Version: 1.0
X-Originating-IP: [95.23.52.8]
In-Reply-To: <20130604211930.GF3618@raspi>
References: <20130604211930.GF3618@raspi>
Date: Wed, 5 Jun 2013 11:21:54 +0200
Message-ID: <CABxcv=m91Q51vYQ-EMCfjTrvinOij_=bTg_vjXrYf7=nYhUbdA@mail.gmail.com>
Subject: Re: [PATCH] cyttsp: Fix swap of mfg_stat and mfg_cmd registers
From: Javier Martinez Canillas <javier@dowhile0.org>
To: Matthias Kaehlcke <matthias.list@kaehlcke.net>,
        Javier Martinez Canillas <javier@dowhile0.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Kevin McNeely <kev@cypress.com>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 4, 2013 at 11:19 PM, Matthias Kaehlcke
<matthias.list@kaehlcke.net> wrote:
> The command and status register in the driver were swapped with
> respect to the order specified in the datasheet (CY8CTMA140).
> Confirmed with Cypress that the order in the datasheet is correct.
>
> Signed-off-by: Matthias Kaehlcke <matthias@kaehlcke.net>
> ---

Acked-by: Javier Martinez Canillas <javier@dowhile0.org>
