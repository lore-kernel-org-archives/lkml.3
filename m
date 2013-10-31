Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755302Ab3JaQAt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Oct 2013 12:00:49 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:57719 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755020Ab3JaQAr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Oct 2013 12:00:47 -0400
Date: Thu, 31 Oct 2013 09:02:50 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Philippe Proulx <philippe.proulx@savoirfairelinux.com>
Cc: Sedat Dilek <sedat.dilek@gmail.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>, Jiri Slaby <jslaby@suse.cz>,
        linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel@savoirfairelinux.com
Subject: Re: [PATCH] serial: omap: fix missing comma
Message-ID: <20131031160250.GA17258@kroah.com>
References: <fa11da334af37a035497c235fa9f5f5cfe11adec.1383226313.git.philippe.proulx@savoirfairelinux.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fa11da334af37a035497c235fa9f5f5cfe11adec.1383226313.git.philippe.proulx@savoirfairelinux.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 31, 2013 at 09:39:58AM -0400, Philippe Proulx wrote:
> Signed-off-by: Philippe Proulx <philippe.proulx@savoirfairelinux.com>
> ---
>  drivers/tty/serial/omap-serial.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Please always credit who told you about the problem with a Reported-by:
tag...

