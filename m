Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030667AbaDBW0b (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2014 18:26:31 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:50765 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030593AbaDBW03 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2014 18:26:29 -0400
Date: Wed, 2 Apr 2014 15:28:51 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Sherif Shehab Aldin <shehabaldin.sherif@gmail.com>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        silentquote@gmail.com
Subject: Re: [PATCH] driver: staging: wlan-ng: Fixed coding style
Message-ID: <20140402222851.GA31598@kroah.com>
References: <1396477016-30951-1-git-send-email-shehabaldin.sherif@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1396477016-30951-1-git-send-email-shehabaldin.sherif@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 03, 2014 at 12:16:56AM +0200, Sherif Shehab Aldin wrote:
> Fixed coding style for hfa384x_usb.c

You do a lot of different types of cleanup in this patch, you are going
to have to be more specific.

Also, only do 1 thing per patch, I see whitespace cleanups, typedef
removal and other things here.  Please break it up into a series of
patches, each doing one thing.

thanks,

greg k-h
