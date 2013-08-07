Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932818Ab3HGTub (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 15:50:31 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:39553 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757135Ab3HGTua (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 15:50:30 -0400
Date: Wed, 7 Aug 2013 12:51:51 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Bob Smith <bsmith@linuxtoys.org>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 001/001] CHAR DRIVERS: a simple device to give daemons a
 /sys-like interface
Message-ID: <20130807195151.GA4121@kroah.com>
References: <51FC5478.40500@linuxtoys.org>
 <51FC5A97.1090102@linuxtoys.org>
 <20130803223828.GA14611@kroah.com>
 <51FECDA6.5070001@linuxtoys.org>
 <20130804231958.GA25418@kroah.com>
 <52003958.7080103@linuxtoys.org>
 <20130806094604.GE27889@kroah.com>
 <520299AB.1020607@linuxtoys.org>
 <20130807192714.GC2708@kroah.com>
 <5202A284.7010106@linuxtoys.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5202A284.7010106@linuxtoys.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 07, 2013 at 12:39:48PM -0700, Bob Smith wrote:
> Greg Kroah-Hartman wrote:
> >>  *    sudo chmod 666 /dev/proxyout /dev/proxyctrl
> >That's mighty permissive :(
> For a demo it might be OK.

You ignored my mknod comment.

Also, no, setting the permissions like this is not ok for a real system,
what is going to be in charge of setting the permissions on these random
device nodes?

greg k-h
