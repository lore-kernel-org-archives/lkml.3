Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752161AbaG0QDj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jul 2014 12:03:39 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:39462 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751676AbaG0QDi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jul 2014 12:03:38 -0400
Date: Sun, 27 Jul 2014 09:03:12 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Rahul Garg <rahul.lnmiit@gmail.com>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: vt6655: coding style: Fixed commenting style
 Few lines were crossing 80 characters limit
Message-ID: <20140727160312.GA18239@kroah.com>
References: <1406460103-28069-1-git-send-email-rahul.lnmiit@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1406460103-28069-1-git-send-email-rahul.lnmiit@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 27, 2014 at 04:51:43PM +0530, Rahul Garg wrote:
> Signed-off-by: Rahul Garg <rahul.lnmiit@gmail.com>
> ---
>  drivers/staging/vt6655/tcrc.c |   11 +++++++----
>  1 file changed, 7 insertions(+), 4 deletions(-)

I know this is a tiny patch, but you are doing two different things
here, and your subject is hugely long.

Can you break this up into 2 different patches, and provide a valid
changelog body for what you are doing?

thanks,

greg k-h
