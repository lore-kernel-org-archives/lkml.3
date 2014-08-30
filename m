Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752141AbaH3U7P (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Aug 2014 16:59:15 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:53952 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751898AbaH3U7O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Aug 2014 16:59:14 -0400
Date: Sat, 30 Aug 2014 13:59:14 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: An Ha <zero579911@gmail.com>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Staging: rtl8821ae: hal_bt_coexist: fix coding style
 issue
Message-ID: <20140830205914.GA2329@kroah.com>
References: <1409422252-3592-1-git-send-email-zero579911@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1409422252-3592-1-git-send-email-zero579911@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 30, 2014 at 02:10:52PM -0400, An Ha wrote:
> Fix coding style issues, these changes include:
> -Add space between "if" and brackets
> -Add space after comma in an argument
> -Add space between equal sign to separate the variable and the assignment
> -Remove unnecessary curly braces around one-line if statements
> -Remove unnecessary whitespace between two brackets
> -Remove unnecessary whitespace before newline
> -Join else-if statement onto same line as end curly brace
> -Join open curly brace onto same line as if statement
> -Use "foo *" instead of "foo*" for the pointer placement
> -Switch commenting style from C99 comments to C89 comments
> 
> Signed-off-by: An Ha <zero579911@gmail.com>

That's a lot of different things all to be doing in one single patch.
Please break this up into "one thing at a time per patch" so that it is
reviewable and readable.

thanks,

greg k-h
