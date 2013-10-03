Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754974Ab3JCSej (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 14:34:39 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:55856 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754562Ab3JCSeh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 14:34:37 -0400
Date: Thu, 3 Oct 2013 11:34:54 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Khalid Aziz <khalid.aziz@oracle.com>
Cc: bhutchings@solarflare.com,
        Christoph Biedl <linux-kernel.bfrz@manchmal.in-ulm.de>,
        stable@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [ 00/13] 3.0.99-stable review
Message-ID: <20131003183454.GA23409@kroah.com>
References: <20131003040400.753642257@linuxfoundation.org>
 <524D0663.209@roeck-us.net>
 <1380801873@msgid.manchmal.in-ulm.de>
 <524D72A7.8030200@oracle.com>
 <1380810793@msgid.manchmal.in-ulm.de>
 <524D85BA.9030603@oracle.com>
 <524D896F.7080801@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <524D896F.7080801@oracle.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 03, 2013 at 09:12:47AM -0600, Khalid Aziz wrote:
> On 10/03/2013 08:56 AM, Khalid Aziz wrote:
> >
> > Greg, please apply the patch Christoph had included in his earlier post.
> >
> > Ben, this will apply to 3.2 as well.
> >
> 
> Better yet, just pull this patch from stable from now. I will redo the 
> patch and send another one for the next round.

Now removed from 3.0 and I'll drop it from 3.4 as well, thanks.

greg k-h
