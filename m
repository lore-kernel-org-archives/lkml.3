Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751629Ab3HTVYf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 17:24:35 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:37662 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751398Ab3HTVYe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 17:24:34 -0400
Date: Tue, 20 Aug 2013 14:24:33 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: dl9pf@gmx.de
Cc: Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [TRIVIAL] Remove braces to fix build for clang. No
 functional change otherwise.
Message-ID: <20130820212433.GA9856@kroah.com>
References: <1377031926-18436-1-git-send-email-dl9pf@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1377031926-18436-1-git-send-email-dl9pf@gmx.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 20, 2013 at 10:52:06PM +0200, dl9pf@gmx.de wrote:
> From: Jan-Simon Möller <dl9pf@gmx.de>
> 
> Author:  PaX Team <pageexec at freemail.hu>
> ML-Post: http://lists.cs.uiuc.edu/pipermail/llvm-commits/Week-of-Mon-20120507/142707.html
> URL:     http://llvm.linuxfoundation.org
> 
> Merge:   Jan-Simon Möller <dl9pf at gmx.de>

What am I supposed to do with these?

> Description:
>   Clang chokes on the notation "inl (%dx)" but works for "inl %dx"; GNU as accepts both forms.

No need for "description", that's implied by the body of the changelog
text.  Also, you can wrap your lines :)

I'll clean this all up by hand, but please do this next time so I don't
have to.

thanks,

greg k-h
