Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753469AbaB0TIm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 14:08:42 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:37292 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751408AbaB0TIk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 14:08:40 -0500
Date: Thu, 27 Feb 2014 11:10:17 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: "rs@mage.me.uk" <rs@mage.me.uk>
Cc: devel@driverdev.osuosl.org, speakup@braille.uwo.ca,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Staging: speakup: buffers: Fixed a return value coding
 style issue.
Message-ID: <20140227191017.GC4755@kroah.com>
References: <1393518402-24860-1-git-send-email-rs@mage.me.uk>
 <20140227164051.GA25183@kroah.com>
 <530F8020.3040000@mage.me.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <530F8020.3040000@mage.me.uk>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 27, 2014 at 06:12:48PM +0000, rs@mage.me.uk wrote:
> When checking buffers.c with checkpatch.pl it throws the following error:
> drivers/staging/speakup/buffers.c:58: ERROR: return is not a function,
> parentheses are not required

Remember, checkpatch.pl is a "guide", not the "law".  Use common sense
when using the tool please.

thanks,

greg k-h
