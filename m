Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754017AbaFRWG6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 18:06:58 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:42556 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751451AbaFRWG5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 18:06:57 -0400
Date: Wed, 18 Jun 2014 15:10:56 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Ian Abbott <abbotti@mev.co.uk>
Cc: driverdev-devel@linuxdriverproject.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: comedi: describe members involved when
 reading/writing buffer
Message-ID: <20140618221056.GA27292@kroah.com>
References: <1401970286-32676-1-git-send-email-abbotti@mev.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1401970286-32676-1-git-send-email-abbotti@mev.co.uk>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 05, 2014 at 01:11:26PM +0100, Ian Abbott wrote:
> Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
> ---
> I was originally going to put it in comedidev.h but as that gets passed
> through the compiler more often, I thought it would be better in
> comedi_buf.c.

Stripping out comments is fast, please put it in the .h file in
kerneldoc format so that tools can pick it out properly.

Oh, and please remove the trailing whitespace you added :)

thanks,

greg k-h
