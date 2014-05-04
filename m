Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753526AbaEDBMW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 May 2014 21:12:22 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:58965 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752897AbaEDBMV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 May 2014 21:12:21 -0400
Date: Sat, 3 May 2014 20:22:28 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Dominique van den Broeck <domdevlin@free.fr>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] staging/rtl8192e: userspace ptr deref + incorrect
 declarations
Message-ID: <20140504002227.GA4132@kroah.com>
References: <1398618676-31095-1-git-send-email-domdevlin@free.fr>
 <1398618676-31095-2-git-send-email-domdevlin@free.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1398618676-31095-2-git-send-email-domdevlin@free.fr>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 27, 2014 at 07:11:16PM +0200, Dominique van den Broeck wrote:
> . userspace pointer dereference ;
> . missing inclusions of needed header files ;
> . unrequired static function declaration (confusing another *.c file).
> 
> Signed-off-by: Dominique van den Broeck <domdevlin@free.fr>
> ---

This patch doesn't apply properly for some reason, can you refresh it
and resend?

thanks,

greg k-h
