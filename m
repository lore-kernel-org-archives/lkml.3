Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932428Ab3LDXzc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 18:55:32 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:36269 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753400Ab3LDXz0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 18:55:26 -0500
Date: Wed, 4 Dec 2013 15:07:21 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
        Rob Landley <rob@landley.net>, Mark Brown <broonie@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>, Grant Likely <grant.likely@linaro.org>
Subject: Re: [PATCH] Documentation: start documenting driver design patterns
Message-ID: <20131204230721.GA9376@kroah.com>
References: <1386159757-29966-1-git-send-email-linus.walleij@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1386159757-29966-1-git-send-email-linus.walleij@linaro.org>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 04, 2013 at 01:22:37PM +0100, Linus Walleij wrote:
> After realizing that we tend to tell developers the same thing over
> and over, let's attempt to document some commin design patterns
> used in the device drivers. The idea is that this can be extended
> so I just start out with two well-known design patterns.
> 
> Cc: Rob Landley <rob@landley.net>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: Mark Brown <broonie@kernel.org>
> Cc: Arnd Bergmann <arnd@arndb.de>
> Cc: Grant Likely <grant.likely@linaro.org>
> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
> ---
> I guess this goes to Greg for merging through the device core
> tree if it is liked, let's see.

No objection from me, I'll be glad to take this, thanks for writing it
up.  Hopefully people will read it (the problem I've found with
documentation in the past when no one actually reads it...)

thanks,

greg k-h
