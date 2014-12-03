Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751812AbaLCKLm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 05:11:42 -0500
Received: from cantor2.suse.de ([195.135.220.15]:53198 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750840AbaLCKLk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 05:11:40 -0500
Date: Wed, 3 Dec 2014 11:11:37 +0100
From: Jean Delvare <jdelvare@suse.de>
To: Pali =?UTF-8?B?Um9ow6Fy?= <pali.rohar@gmail.com>
Cc: Guenter Roeck <linux@roeck-us.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Steven Honeyman <stevenhoneyman@gmail.com>,
        linux-kernel@vger.kernel.org,
        Gabriele Mazzotta <gabriele.mzt@gmail.com>
Subject: Re: [PATCH] i8k: Add support for temperature sensor labels
Message-ID: <20141203111137.46165136@endymion.delvare>
In-Reply-To: <1417598726.14672.6.camel@Pali-Nokia-N900>
References: <1417277047-15489-1-git-send-email-pali.rohar@gmail.com>
	<201411291849.44032@pali>
	<20141129175152.GA32510@kroah.com>
	<201411291904.07644@pali>
	<1417526599.15239.7.camel@chaos.site>
	<547DCC15.70300@roeck-us.net>
	<20141203100928.14d23c9f@endymion.delvare>
	<1417598726.14672.6.camel@Pali-Nokia-N900>
Organization: SUSE Linux
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.23; x86_64-suse-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 03 Dec 2014 10:25:26 +0100, Pali Rohár wrote:
> Anyway, what does i8k mean? That dell interface is somehow called DELLDIAG, so I do not know what i8k means...

I think i8k stands for "Inspiron 8000", most likely the first model
supported by that driver:
http://www.dell.com/support/home/us/en/19/product-support/product/inspiron-8000/manuals

-- 
Jean Delvare
SUSE L3 Support
