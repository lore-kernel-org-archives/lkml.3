Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755893AbaIQPWx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2014 11:22:53 -0400
Received: from mail-wg0-f42.google.com ([74.125.82.42]:48142 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755877AbaIQPWv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2014 11:22:51 -0400
Message-ID: <1410967369.5542.2.camel@lp-lvrv.comap.cz>
Subject: Re: [PATCH v2] watchdog: omap_wdt: Add 'early_disable' module
 parameter
From: Rostislav Lisovy <lisovy@gmail.com>
To: Guenter Roeck <linux@roeck-us.net>
Cc: Wim Van Sebroeck <wim@iguana.be>, linux-watchdog@vger.kernel.org,
        linux-kernel@vger.kernel.org, sojkam1@fel.cvut.cz,
        michal.vokac@comap.cz, Rostislav Lisovy <lisovy@merica.cz>
Date: Wed, 17 Sep 2014 17:22:49 +0200
In-Reply-To: <20140916154921.GA14725@roeck-us.net>
References: <1410877228-20925-1-git-send-email-lisovy@merica.cz>
	 <20140916154921.GA14725@roeck-us.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4-0ubuntu2 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Guenter;
Thanks for the review.

On Út, 2014-09-16 at 08:49 -0700, Guenter Roeck wrote:
> How do you know that the watchdog was already running ?
> Seems to me you are just making an assumption that it is running
> without really knowing for sure.

You are definitely right, however the OMAP Watchdog seems to be such a
sophisticated piece of hardware that there is no possible way how to
determine if it is running or not (sampling timer counter twice and
comparing both values is they differ is stupid).

Best regards;
Rostislav

