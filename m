Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934208Ab3CMTzw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Mar 2013 15:55:52 -0400
Received: from casper.infradead.org ([85.118.1.10]:36525 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932236Ab3CMTzv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Mar 2013 15:55:51 -0400
Message-ID: <5140D9DF.4010506@infradead.org>
Date: Wed, 13 Mar 2013 12:56:15 -0700
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130215 Thunderbird/17.0.3
MIME-Version: 1.0
To: Thomas Meyer <thomas@m3y3r.de>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: CONFIG_EARLY_PRINTK
References: <1363194921.1218.14.camel@localhost.localdomain>
In-Reply-To: <1363194921.1218.14.camel@localhost.localdomain>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/13/13 10:15, Thomas Meyer wrote:
> Hi,
> 
>  -*- Early printk 
> 
> help text says:
> "You should normally N here, unless you want to debug such a crash.
> (Depends on: EXPERT [=n])"
> 
> How to normally N here?

You'll have to enable CONFIG_EXPERT and then you can disable EARLY_PRINTK.

You may even have to disable CONFIG_EMBEDDED before you can enable
CONFIG_EXPERT (I did).

Too many hoops to have to jump through.   :(


-- 
~Randy
