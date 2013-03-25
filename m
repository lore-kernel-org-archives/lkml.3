Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933313Ab3CYUSE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Mar 2013 16:18:04 -0400
Received: from mail-pd0-f173.google.com ([209.85.192.173]:64365 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933156Ab3CYUSC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Mar 2013 16:18:02 -0400
Date: Mon, 25 Mar 2013 13:17:59 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: H Hartley Sweeten <hartleys@visionengravers.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
        Ryan Mallon <rmallon@gmail.com>, arnd@arndb.de
Subject: Re: [PATCH 3/3] misc: ep93xx_pwm.c: fix section mismatch and use
 module_platform_driver
Message-ID: <20130325201759.GA30544@kroah.com>
References: <201303151807.14074.hartleys@visionengravers.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201303151807.14074.hartleys@visionengravers.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 15, 2013 at 06:07:13PM -0700, H Hartley Sweeten wrote:
> Remove the __init tags from the ep93xx_pwm_probe() and
> ep93xx_pwm_remove() functions to fix the section mismatch
> warnings.
> 
> Use module_platform_driver() to remove the init/exit boilerplate.
> 
> Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
> Cc: Ryan Mallon <rmallon@gmail.com>

Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

