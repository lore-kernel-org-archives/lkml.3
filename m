Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752424AbaF0EFy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2014 00:05:54 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:35554 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751104AbaF0EFk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2014 00:05:40 -0400
Date: Thu, 26 Jun 2014 19:28:21 -0400
From: Greg KH <gregkh@linuxfoundation.org>
To: Raphael Poggi <poggi.raph@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2 RESEND] staging: lirc: fix checkpath errors: blank
 lines
Message-ID: <20140626232821.GB26949@kroah.com>
References: <1403680471-13212-1-git-send-email-poggi.raph@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1403680471-13212-1-git-send-email-poggi.raph@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 25, 2014 at 09:14:30AM +0200, Raphael Poggi wrote:
> This patch fix checkpath "WARNING: Missing a blank line after declarations"
> 
> Signed-off-by: Raphaël Poggi <poggi.raph@gmail.com>
> ---
>  drivers/staging/media/lirc/lirc_imon.c |    3 +++

Please use scripts/get_maintainer.pl to find out who patches for this
file should be sent to (hint, it's not me...)

thanks,

greg k-h
