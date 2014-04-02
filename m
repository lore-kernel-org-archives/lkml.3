Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161075AbaDBXp6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2014 19:45:58 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:51259 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161040AbaDBXp5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2014 19:45:57 -0400
Date: Wed, 2 Apr 2014 16:48:10 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Joe Perches <joe@perches.com>
Cc: Sherif <silentquote@gmail.com>,
        Sherif Shehab Aldin <shehabaldin.sherif@gmail.com>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] driver: staging: wlan-ng: Fixed Breaking long lines and
 strings style rule
Message-ID: <20140402234810.GA545@kroah.com>
References: <1396480678-32036-1-git-send-email-shehabaldin.sherif@gmail.com>
 <1396480892.32040.17.camel@joe-AO722>
 <533C9F2A.9000102@gmail.com>
 <1396482038.32040.19.camel@joe-AO722>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1396482038.32040.19.camel@joe-AO722>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 02, 2014 at 04:40:38PM -0700, Joe Perches wrote:
> On Thu, 2014-04-03 at 01:37 +0200, Sherif wrote:
> > BTW regarding "Alignment should match open parenthesis" rule, It's 
> > missing from Documentation/CodingStyle
> 
> It's "maintainer's preference" in at least
> net/, drivers/net and drivers/staging.
> 
> Maybe it's true for drivers/usb too.
> 
> Greg?

Yes, I "prefer" that as well, but if that's the only thing wrong with
the code, I really don't care.

thanks,

greg k-h
