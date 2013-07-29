Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753612Ab3G2T2j (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jul 2013 15:28:39 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:58654 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751128Ab3G2T2i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jul 2013 15:28:38 -0400
Date: Mon, 29 Jul 2013 12:28:37 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Randy Dunlap <rdunlap@infradead.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        Jonathan Kim <jonathankim@gctsemi.com>, Dean ahn <deanahn@gctsemi.com>
Subject: Re: linux-next: Tree for Jul 29 (staging/gdm724x)
Message-ID: <20130729192837.GB9191@kroah.com>
References: <20130729163906.7ba07f7c024ad364b2feb513@canb.auug.org.au>
 <51F6A0A9.5040702@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51F6A0A9.5040702@infradead.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 29, 2013 at 10:04:41AM -0700, Randy Dunlap wrote:
> On 07/28/13 23:39, Stephen Rothwell wrote:
> > Hi all,
> > 
> > Changes since 20130726:
> > 
> 
> on i386:
> # CONFIG_TTY is not set

Thanks, now fixed.

greg k-h
