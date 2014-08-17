Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751479AbaHQQyB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Aug 2014 12:54:01 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:56893 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750962AbaHQQyA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Aug 2014 12:54:00 -0400
Date: Sun, 17 Aug 2014 09:53:23 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Oleg Drokin <green@linuxhacker.ru>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 10/10] lustre: Add some basic documentation
Message-ID: <20140817165323.GA13239@kroah.com>
References: <1408121295-29115-1-git-send-email-green@linuxhacker.ru>
 <1408121295-29115-11-git-send-email-green@linuxhacker.ru>
 <20140817163758.GB15982@kroah.com>
 <73475176-52A2-4030-88D6-DBDED4A83E0F@linuxhacker.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <73475176-52A2-4030-88D6-DBDED4A83E0F@linuxhacker.ru>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 17, 2014 at 12:49:30PM -0400, Oleg Drokin wrote:
> 
> On Aug 17, 2014, at 12:37 PM, Greg Kroah-Hartman wrote:
> 
> > On Fri, Aug 15, 2014 at 12:48:15PM -0400, Oleg Drokin wrote:
> >> This adds Documentation/filesystems/lustre.txt with some
> >> basic information about Lustre and how to use it.
> >> 
> >> Signed-off-by: Oleg Drokin <green@linuxhacker.ru>
> >> ---
> >> Documentation/filesystems/lustre.txt | 87 ++++++++++++++++++++++++++++++++++++
> > 
> > No, don't break out of drivers/staging/lustre/ just yet please.
> 
> Sure, should I just add this somewhere inside drivers/staging/lustre so that it's not lost
> and people have some starting info?

That would be great.

thanks,

greg k-h
