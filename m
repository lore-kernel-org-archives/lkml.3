Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754191AbaKCSPQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 13:15:16 -0500
Received: from mail-out.m-online.net ([212.18.0.10]:57130 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752482AbaKCSPK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 13:15:10 -0500
X-Auth-Info: QzCpKptf8HmzcGgHIpi8ivb2PLGvKVLwyvHCT4RoJjZfHMQoaYt8Wi+Ibvgf4hbJ
From: Andreas Schwab <schwab@linux-m68k.org>
To: Geert Uytterhoeven <geert+renesas@glider.be>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>, Simon Horman <horms@verge.net.au>,
        Magnus Damm <magnus.damm@gmail.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Kevin Hilman <khilman@linaro.org>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Philipp Zabel <philipp.zabel@gmail.com>,
        Tomasz Figa <tomasz.figa@gmail.com>, linux-sh@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 1/9] PM / Domains: Change prototype for the ->attach_dev() callback
References: <1415028896-9005-1-git-send-email-geert+renesas@glider.be>
	<1415028896-9005-2-git-send-email-geert+renesas@glider.be>
X-Yow: The entire CHINESE WOMEN'S VOLLEYBALL TEAM all share ONE personality --
 and have since BIRTH!!
Date: Mon, 03 Nov 2014 19:15:04 +0100
In-Reply-To: <1415028896-9005-2-git-send-email-geert+renesas@glider.be> (Geert
	Uytterhoeven's message of "Mon, 3 Nov 2014 16:34:48 +0100")
Message-ID: <8761ewduc7.fsf@igel.home>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Geert Uytterhoeven <geert+renesas@glider.be> writes:

> From: Ulf Hansson <ulf.hansson@linaro.org>
>
> Convert the prototype to return and int. This is just an initial step,

s/and/an/

Andreas.

-- 
Andreas Schwab, schwab@linux-m68k.org
GPG Key fingerprint = 58CA 54C7 6D53 942B 1756  01D3 44D5 214B 8276 4ED5
"And now for something completely different."
