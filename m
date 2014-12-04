Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753597AbaLDKQU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 05:16:20 -0500
Received: from cantor2.suse.de ([195.135.220.15]:48925 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753086AbaLDKQS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 05:16:18 -0500
Date: Thu, 4 Dec 2014 11:16:11 +0100
From: Jean Delvare <jdelvare@suse.de>
To: Guenter Roeck <linux@roeck-us.net>
Cc: Pali =?UTF-8?B?Um9ow6Fy?= <pali.rohar@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Steven Honeyman <stevenhoneyman@gmail.com>,
        linux-kernel@vger.kernel.org,
        Gabriele Mazzotta <gabriele.mzt@gmail.com>
Subject: Re: [PATCH] i8k: Add support for temperature sensor labels
Message-ID: <20141204111611.32992a05@endymion.delvare>
In-Reply-To: <20141203191446.GD9845@roeck-us.net>
References: <1417277047-15489-1-git-send-email-pali.rohar@gmail.com>
	<201411291849.44032@pali>
	<20141129175152.GA32510@kroah.com>
	<201411291904.07644@pali>
	<1417526599.15239.7.camel@chaos.site>
	<547DCC15.70300@roeck-us.net>
	<20141203100928.14d23c9f@endymion.delvare>
	<20141203191446.GD9845@roeck-us.net>
Organization: SUSE Linux
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.23; x86_64-suse-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 3 Dec 2014 11:14:46 -0800, Guenter Roeck wrote:
> A quick glance into Lauchpad shows that i8kutils is still maintained
> and used, including the sometimes dirty tricks it provides. 

Don't draw conclusions too fast though... People may just not have
realized that they no longer need it. Old tricks are hard to forget.

The only way to make sure is to find current users of i8kutils and see
what they (think they would) lose if i8kutils goes away.

-- 
Jean Delvare
SUSE L3 Support
