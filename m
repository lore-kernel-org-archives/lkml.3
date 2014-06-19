Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758037AbaFSWpg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 18:45:36 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:52481 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754692AbaFSWpf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 18:45:35 -0400
Date: Thu, 19 Jun 2014 15:49:35 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Tair Rzayev <tair.rzayev@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: media: solo6x10: solo6x10-jpeg.h: Fix sparse
 warning
Message-ID: <20140619224935.GA15181@kroah.com>
References: <538A3BD7.7000607@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <538A3BD7.7000607@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 31, 2014 at 11:30:15PM +0300, Tair Rzayev wrote:
> Make jpeg_dqt[][] static
> 
> Signed-off-by: Tair Rzayev <tair.rzayev@gmail.com>
> ---
>  drivers/staging/media/solo6x10/solo6x10-jpeg.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Please always use scripts/get_maintainer.pl to determine who to send
patches to (hint, I can't do anything with this one...)

greg k-h
