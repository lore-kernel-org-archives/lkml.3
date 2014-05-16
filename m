Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992461AbaEPTJN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 15:09:13 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:50398 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992446AbaEPTJL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 15:09:11 -0400
Date: Fri, 16 May 2014 12:12:30 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Junsu Shin <jsshin.dev@gmail.com>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Staging: gdm72xx: gdm_wimax: Fixed coding style issues.
Message-ID: <20140516191230.GA13758@kroah.com>
References: <1398711011-3834-1-git-send-email-jsshin.dev@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1398711011-3834-1-git-send-email-jsshin.dev@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 28, 2014 at 01:50:11PM -0500, Junsu Shin wrote:
> Fixed following coding style issues.
>  - No space is necessary after a cast
>  - Alignment should match open parenthesis
>  - Braces {} should be used on all arms of this statement

You are doing 3 things, so this should be 3 patches at the least.
Remember, one patch per "thing".

> Signed-off-by: Junsu Shin <jsshin.dev@gmail.com>x

What is the trailing 'x' for?

thanks,

greg k-h
