Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753719Ab3IWNbY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 09:31:24 -0400
Received: from www.linutronix.de ([62.245.132.108]:50574 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753493Ab3IWNbW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 09:31:22 -0400
Message-ID: <524042A2.2070005@linutronix.de>
Date: Mon, 23 Sep 2013 15:31:14 +0200
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130821 Icedove/17.0.8
MIME-Version: 1.0
To: Matthias Kaehlcke <matthias.list@kaehlcke.net>,
        Jonathan Cameron <jic23@cam.ac.uk>, "Patil, Rachna" <rachna@ti.com>,
        Felipe Balbi <balbi@ti.com>,
        Pantelis Antoniou <panto@antoniou-consulting.com>,
        linux-iio@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] iio: ti_am335x_adc: Take touchscreen channels into
 account for conversion timeout
References: <f1830a7d0debce351966d2f3232158313d87dcc0.1378846446.git.matthias@kaehlcke.net> <20130910210228.GC30481@raspi>
In-Reply-To: <20130910210228.GC30481@raspi>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/10/2013 11:02 PM, Matthias Kaehlcke wrote:
> The calculation of the old conversion timeout value was based on the number of
> channels used by this driver. This doesn't take into account that other channels
> can be used by the touchscreen driver. Adjust the timeout value to the maximum
> if the touchscreen driver is enabled

What bug / miss behave are you trying to fix?
The difference in timming is minimal and therefore I would prefer to get
rid of this ifdef and assume the max value of those two instead.

Sebastian
