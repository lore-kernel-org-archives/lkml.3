Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753281Ab3KSXFV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Nov 2013 18:05:21 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:42378 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752152Ab3KSXFS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Nov 2013 18:05:18 -0500
Date: Tue, 19 Nov 2013 15:05:36 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Peter Hurley <peter@hurleysoftware.com>
Cc: Heorhi Valakhanovich <valahanovich@tut.by>,
        One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org
Subject: Re: [PATCH] tty: Only hangup once
Message-ID: <20131119230536.GA13504@kroah.com>
References: <1375293945-4087-1-git-send-email-peter@hurleysoftware.com>
 <20131117203850.46df2124@tormoz-pc>
 <20131118134211.17861db3@alan.etchedpixels.co.uk>
 <528A5043.6030901@hurleysoftware.com>
 <528A797B.6020807@hurleysoftware.com>
 <20131119000923.5ca40e51@tormoz-pc>
 <528B6BB3.7020303@hurleysoftware.com>
 <20131119201952.2d63b8ce@tormoz-pc>
 <20131119174032.GB22604@kroah.com>
 <528BD95B.3070400@hurleysoftware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <528BD95B.3070400@hurleysoftware.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 19, 2013 at 04:34:19PM -0500, Peter Hurley wrote:
> On 11/19/2013 12:40 PM, Greg KH wrote:
> > It should be backported to 3.12, and any other kernels?
> 
> Greg,
> 
> This patch should apply cleanly to 3.12.
> 
> The first commit to rely on the correct TTY_HUPPED state was
> commit 36697529b5bbe36911e39a6309e7a7c9250d280a,
>     'tty: Replace ldisc locking with ldisc_sem'
> which was introduced in the 3.12 cycle.
> 
> Regards,
> Peter Hurley
> 
> PS - Did you receive 'n_tty: Fix echo overrun tail computation'?
> I saw it didn't make 3.12.1.

Yes, I got it, I can't apply anything to my trees until 3.13-rc1 is out,
and because it's not in Linus's tree yet, I can't apply it to a stable
tree.  So give us a few weeks, don't worry, it's not lost.

greg k-h
