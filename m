Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751641AbbARBfM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Jan 2015 20:35:12 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:56981 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751225AbbARBfK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Jan 2015 20:35:10 -0500
Date: Sat, 17 Jan 2015 17:07:55 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Joe Perches <joe@perches.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] device: Change dev_<level> logging functions to return
 void
Message-ID: <20150118010755.GA21760@kroah.com>
References: <1419548824.6157.19.camel@perches.com>
 <1421542580.29879.2.camel@perches.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1421542580.29879.2.camel@perches.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 17, 2015 at 04:56:20PM -0800, Joe Perches wrote:
> On Thu, 2014-12-25 at 15:07 -0800, Joe Perches wrote:
> > No caller or macro uses the return value so make all
> > the functions return void.
> 
> Ping?

It's in my queue, just starting to dig out from under it, give me a few
more days please, it's not lost.

thanks,

greg k-h
