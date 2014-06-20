Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966080AbaFTUDI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 16:03:08 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:60653 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751904AbaFTUDH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 16:03:07 -0400
Date: Fri, 20 Jun 2014 13:07:07 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: Jiri Kosina <trivial@kernel.org>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] trivial: drivers/staging/rtl8821ae/rtl8821ae: Fix
 closing brace followed by if
Message-ID: <20140620200707.GA16329@kroah.com>
References: <1403294195-18209-1-git-send-email-linux@rasmusvillemoes.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1403294195-18209-1-git-send-email-linux@rasmusvillemoes.dk>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 20, 2014 at 09:56:35PM +0200, Rasmus Villemoes wrote:
> All of the code is #if 0'd out, and the change just replaces a
> space with a newline, so this obviously doesn't change anything.

How about just deleting all the #if 0 code out entirely so no one has to
worry about it anymore?

thanks,

greg k-h
