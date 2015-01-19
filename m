Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751982AbbASWhI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2015 17:37:08 -0500
Received: from mail-wg0-f46.google.com ([74.125.82.46]:65351 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751836AbbASWhE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2015 17:37:04 -0500
From: Peter Korsgaard <peter@korsgaard.com>
To: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Cc: linux-gpio@vger.kernel.org, linux-kernel@vger.kernel.org,
        Linus Walleij <linus.walleij@linaro.org>,
        Alexandre Courbot <gnurou@gmail.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, Peter Korsgaard <jacmet@sunsite.dk>,
        devicetree@vger.kernel.org
Subject: Re: [PATCH 7/8] gpio/mpc8xxx: Convert to platform device interface.
References: <1421581173-28416-1-git-send-email-ricardo.ribalda@gmail.com>
	<1421581173-28416-8-git-send-email-ricardo.ribalda@gmail.com>
Date: Mon, 19 Jan 2015 23:36:59 +0100
In-Reply-To: <1421581173-28416-8-git-send-email-ricardo.ribalda@gmail.com>
	(Ricardo Ribalda Delgado's message of "Sun, 18 Jan 2015 12:39:32
	+0100")
Message-ID: <87oapu9z3o.fsf@dell.be.48ers.dk>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Ricardo" == Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com> writes:

 > This way we do not need to transverse the device tree manually.
 > Cc: Linus Walleij <linus.walleij@linaro.org>
 > Cc: Alexandre Courbot <gnurou@gmail.com>
 > Cc: Grant Likely <grant.likely@linaro.org>
 > Cc: Rob Herring <robh+dt@kernel.org>
 > Cc: Peter Korsgaard <jacmet@sunsite.dk>
 > Cc: devicetree@vger.kernel.org
 > Signed-off-by: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>

Looks sensible.

Acked-by: Peter Korsgaard <peter@korsgaard.com>

-- 
Bye, Peter Korsgaard
