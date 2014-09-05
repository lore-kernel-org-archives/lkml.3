Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751866AbaIES7d (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 14:59:33 -0400
Received: from mail-pd0-f176.google.com ([209.85.192.176]:49628 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750940AbaIES7c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 14:59:32 -0400
Date: Fri, 5 Sep 2014 11:59:26 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Steven Honeyman <stevenhoneyman@gmail.com>
Cc: Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] i8k: Add support for Dell Latitude E6540
Message-ID: <20140905185926.GA26476@roeck-us.net>
References: <1409936622-5241-1-git-send-email-stevenhoneyman@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1409936622-5241-1-git-send-email-stevenhoneyman@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 05, 2014 at 06:03:42PM +0100, Steven Honeyman wrote:
> Add support for the Dell Latitude E6540 which needs a different fan speed multiplier.
> 
> Signed-off-by: Steven Honeyman <stevenhoneyman@gmail.com>

Looks good.

Reviewed-by: Guenter Roeck <linux@roeck-us.net>

Greg / Arnd, can you pick this up directly, or should I send
a pull request ?

Thanks,
Guenter
