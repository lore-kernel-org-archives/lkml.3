Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751845AbaBNKT4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Feb 2014 05:19:56 -0500
Received: from mail-we0-f172.google.com ([74.125.82.172]:35781 "EHLO
	mail-we0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751562AbaBNKTz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Feb 2014 05:19:55 -0500
Date: Fri, 14 Feb 2014 10:19:49 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Laszlo Papp <lpapp@kde.org>
Cc: Mark Brown <broonie@kernel.org>, Linus Walleij <linus.walleij@linaro.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Sachin Kamat <sachin.kamat@linaro.org>,
        Jean Delvare <jdelvare@suse.de>, Guenter Roeck <linux@roeck-us.net>
Subject: Re: [PATCH v6] mfd: MAX6650/6651 support
Message-ID: <20140214101949.GD9462@lee--X1>
References: <1392177760-17959-1-git-send-email-lpapp@kde.org>
 <20140212175018.GJ28112@sirena.org.uk>
 <CAOMwXhNd69KMDcBLjfiw16T3bWWki-Dvxbz+zhgNe6OESnVaSw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAOMwXhNd69KMDcBLjfiw16T3bWWki-Dvxbz+zhgNe6OESnVaSw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> >> +     mutex_init(&max665x->iolock);
> >
> > What is this needed for?
> 
> It was done for consistency with the other mfd drivers (maxim), e.g.
> 8997 or 8998 as the closest resemblence in this family. Would you
> prefer me removing this mutex locker?

If you're not using mutexes, why would you need to initialise it?

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
