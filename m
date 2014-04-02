Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933140AbaDBTaE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2014 15:30:04 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:49576 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933040AbaDBTaA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2014 15:30:00 -0400
Date: Wed, 2 Apr 2014 12:32:22 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Takashi Iwai <tiwai@suse.de>
Cc: Arnd Bergmann <arnd@arndb.de>, Jean Delvare <jdelvare@suse.de>,
        Struan Bartlett <struan.bartlett@gmail.com>,
        Andreas Schwab <schwab@linux-m68k.org>, gnomes@lxorguk.ukuu.org.uk,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] ttyprintk: Allow built as a module
Message-ID: <20140402193222.GA26425@kroah.com>
References: <1396434582-30799-1-git-send-email-tiwai@suse.de>
 <1396434582-30799-2-git-send-email-tiwai@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1396434582-30799-2-git-send-email-tiwai@suse.de>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 02, 2014 at 12:29:42PM +0200, Takashi Iwai wrote:
> The driver is well written to be used as a module, just the exit call
> is missing.
> 
> Signed-off-by: Takashi Iwai <tiwai@suse.de>
> ---
>  drivers/char/Kconfig     |  2 +-
>  drivers/char/ttyprintk.c | 13 ++++++++++++-
>  2 files changed, 13 insertions(+), 2 deletions(-)

There was some reason we didn't do this back when the code was accepted,
but I really can't remember why.

If you have tested this out, I don't have any objections to taking these
patches, thanks.

greg k-h
