Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752532Ab3LSCjQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 21:39:16 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:38680 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751210Ab3LSCjP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 21:39:15 -0500
Date: Wed, 18 Dec 2013 16:19:35 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Michael Hoefler <michael.hoefler@studium.uni-erlangen.de>
Cc: linux-kernel@i4.cs.fau.de, Christoph Kohl <christoph.kohl@t-online.de>,
        Chad Williamson <chad@dahc.us>, Randy Dunlap <rdunlap@infradead.org>,
        "open list:STAGING SUBSYSTEM" <devel@driverdev.osuosl.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] silicom: fixed checkpatch issues in bypass.c
Message-ID: <20131219001935.GA918@kroah.com>
References: <1387410312-32301-1-git-send-email-michael.hoefler@studium.uni-erlangen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1387410312-32301-1-git-send-email-michael.hoefler@studium.uni-erlangen.de>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 19, 2013 at 12:45:09AM +0100, Michael Hoefler wrote:
> This patch cleans up bypass.c of the silicom driver in the staging area. All
> errors and most warnings according to checkpatch.pl should be fixed.
> 
> There are still two warnings left related to too many leading tabs at nested
> blocks. I did not touch this issue because the code needs really some
> refactoring and since i don't have the hardware to test the code. So this patch
> does not change the business logic in any way.
> 
> But we address different types of problems.
> For example:
>  - missing braces
>  - lines over 80 characters
>  - unnecessary forward declarations
>  - assignment in if condition
>  - whitespace stuff
>  - a C++ one line comment
>  - parenthesis at return statements
>  - missing __init and __exit macros

You are doing a lot of different things here, making this hard to
review.

How about splitting this up into at least two different patches, one
that does the code formatting cleanups, and the other the "logical"
changes needed to make codingstyle happy?

Remember, one patch should only do one thing, if you have to list a
series of things a single patch does, that's not good, it should be
split up.

thanks,

greg k-h
