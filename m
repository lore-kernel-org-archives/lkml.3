Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966921Ab3DROXT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Apr 2013 10:23:19 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:49510 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964949Ab3DROXS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Apr 2013 10:23:18 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: Re: [PATCH 18/19] ARM: at91: suspend both memory controllers on at91sam9263
Date: Thu, 18 Apr 2013 16:20:42 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-18-generic; KDE/4.3.2; x86_64; ; )
Cc: Daniel Lezcano <daniel.lezcano@linaro.org>,
        "Jean-Christophe Plagniol-Villard" <plagnioj@jcrosoft.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Andrew Victor <linux@maxim.org.za>,
        Albin Tonnerre <albin.tonnerre@free-electrons.com>
References: <1359123276-15833-1-git-send-email-arnd@arndb.de> <201304181615.20542.arnd@arndb.de> <51700105.9080802@atmel.com>
In-Reply-To: <51700105.9080802@atmel.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201304181620.42940.arnd@arndb.de>
X-Provags-ID: V02:K0:OiBCAj8nGab6ZxG3BTBbgP//mDwjCs92rAsh9LEQ2qo
 9oH7xkEIXByl1vBrBjVV0sTGcffBkGMnur1hRJhJ6m7P8p7Bk8
 3IpJOX0SvGUWFo4j0iqg7Y2dyyf338gyb8r2Zg6K7bD+4D6AxX
 i/4zIGhL0hHaZzlSd2lByQh3flVklgDnCDBpxp6B9B7E8vmHNP
 tdGy4VHmhDk5s4+iPqxUOs25i7WK1Z9qlUzY8pJWQLxObkNzHA
 ZBk6Kakoh1Z7+XHkZfz09POMgz2ZPcGSU+/HKYkKnJT9kioR53
 MIeejhLIGeMVrOxka8K943A6ni7OFXhEW7ElDEX0gi0FWN6dV+
 NCXTbHUu+HHdnomdvKIs=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 18 April 2013, Nicolas Ferre wrote:
> > Maybe you can make sure it actually works and send it to Daniel to apply on
> > top of his other patches?
> 
> Well, as Daniel's patches are still under construction, I stack this one
> on the at91-3.10-soc branch and let Daniel rebase his work on top of a
> 3.10-rc1-ish tree...

Ok, sounds fine too.

	Arnd
