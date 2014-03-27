Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756816AbaC0N1n (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2014 09:27:43 -0400
Received: from mail-we0-f180.google.com ([74.125.82.180]:60042 "EHLO
	mail-we0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756694AbaC0N1m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2014 09:27:42 -0400
Message-ID: <53342749.6060403@gmail.com>
Date: Thu, 27 Mar 2014 14:27:37 +0100
From: Boris BREZILLON <b.brezillon.dev@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Fabio Estevam <festevam@gmail.com>,
        Boris BREZILLON <brezillonboris@gmail.com>
CC: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Mike Turquette <mturquette@linaro.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Russell King <linux@arm.linux.org.uk>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Kevin Hilman <khilman@linaro.org>, Shawn Guo <shawn.guo@linaro.org>,
        Sascha Hauer <kernel@pengutronix.de>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
Subject: Re: [PATCH] ARM: imx6/dt: add ccm dependency upon ckil, ckih1 and
 osc clocks
References: <5333DA13.2080505@gmail.com>	<1395907913-23808-1-git-send-email-b.brezillon.dev@gmail.com> <CAOMZO5D+rinC8zDMGTS9ACA1nBQvy8X3PqXc7iyWToS54amesw@mail.gmail.com>
In-Reply-To: <CAOMZO5D+rinC8zDMGTS9ACA1nBQvy8X3PqXc7iyWToS54amesw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le 27/03/2014 12:19, Fabio Estevam a écrit :
> On Thu, Mar 27, 2014 at 5:11 AM, Boris BREZILLON
> <brezillonboris@gmail.com> wrote:
>> Signed-off-by: Boris BREZILLON <b.brezillon.dev@gmail.com>
> Please provide a commit message, thanks.

This was sent as a test to verify my assumptions.

But if you want a commit message, how about this one ?

Define ccm clocks dependencies upon ckil, ckih1 and osc fixed clocks
to enforce probing order.

Anyway this patch is buggy (see my previous answer) and I'm not sure
I'm one that should submit it :-).

Best Regards,

Boris
