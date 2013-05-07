Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752881Ab3EGRJb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 13:09:31 -0400
Received: from casper.infradead.org ([85.118.1.10]:55812 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752159Ab3EGRJ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 13:09:29 -0400
Message-ID: <51893523.9000105@infradead.org>
Date: Tue, 07 May 2013 10:08:51 -0700
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jonathan Cameron <jic23@cam.ac.uk>, linux-iio@vger.kernel.org
Subject: Re: linux-next: Tree for May 7 (iio)
References: <20130507134922.981483ab1e5cb09e5543a6cc@canb.auug.org.au>
In-Reply-To: <20130507134922.981483ab1e5cb09e5543a6cc@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/06/13 20:49, Stephen Rothwell wrote:
> Hi all,
> 
> Please do not add any v3.11 destined work to your linux-next included
> branches until after v3.10-rc1 is released.
> 
> I am receiving a (un)reasonable number of conflicts from there being
> multiple copies of some commits in various trees.   Please clean this up
> and resist the temptataion to rebase your trees on the way to your
> upstream ...
> 
> Changes since 20130506:
> 

on x86_64:

when CONFIG_AD5446=y and CONFIG_I2C=m:

drivers/built-in.o: In function `ad5622_write':
ad5446.c:(.text+0xae0b5): undefined reference to `i2c_master_send'
drivers/built-in.o: In function `ad5446_init':
ad5446.c:(.init.text+0x4f28): undefined reference to `i2c_register_driver'
drivers/built-in.o: In function `ad5446_i2c_unregister_driver':
ad5446.c:(.exit.text+0xc73): undefined reference to `i2c_del_driver'



-- 
~Randy
