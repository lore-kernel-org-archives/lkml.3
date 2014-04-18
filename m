Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751217AbaDRGPJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2014 02:15:09 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:35648 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750976AbaDRGPE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2014 02:15:04 -0400
Date: Thu, 17 Apr 2014 23:15:10 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Bastien Armand <armand.bastien@laposte.net>
Cc: Willy Tarreau <willy@meta-x.org>,
        Monam Agarwal <monamagarwal123@gmail.com>,
        Jake Champlin <jake.champlin.27@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: panel: fix sparse warnings
Message-ID: <20140418061510.GA8415@kroah.com>
References: <20140418060122.GA477@plop.dartybox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140418060122.GA477@plop.dartybox.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 18, 2014 at 08:01:22AM +0200, Bastien Armand wrote:
> This patch fixes sparse warnings in panel.c.

What sparse warnings were fixed here?

It looks like you did a lot of different things, can you please break
this out into "one patch per logical change" so it can be reviewed
easier?

thanks,

greg k-h
