Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753243AbbAQXk4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Jan 2015 18:40:56 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:56012 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752054AbbAQXkz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Jan 2015 18:40:55 -0500
Date: Sat, 17 Jan 2015 15:23:49 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Bilel DRIRA <bilel.dr@gmail.com>
Cc: marek.belisko@gmail.com, joe@perches.com, tapaswenipathak@gmail.com,
        gdonald@gmail.com, aybuke.147@gmail.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, linux-next@vger.kernel.org
Subject: Re: [PATCH v2 ] staging: ft1000: fix else style error
Message-ID: <20150117232349.GA27066@kroah.com>
References: <1421184840-24108-1-git-send-email-bilel.dr@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1421184840-24108-1-git-send-email-bilel.dr@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 13, 2015 at 10:34:00PM +0100, Bilel DRIRA wrote:
> This patch fix the checkpatch.pl error:
> 
> 	ERROR: else should follow close brace '}'
> 
> Signed-off-by: Bilel DRIRA <bilel.dr@gmail.com>
> ---
> v2: remove braces instead of just putting else after close brace. (suggested by Joe Perches).
> 
>  drivers/staging/ft1000/ft1000-pcmcia/ft1000_hw.c |   29 ++++++++--------------
>  1 file changed, 10 insertions(+), 19 deletions(-)

Doesn't apply to my tree due to changes from other developers before you
in this area, sorry.

greg k-h
