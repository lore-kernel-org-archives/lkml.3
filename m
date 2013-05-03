Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763372Ab3EDAop (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 May 2013 20:44:45 -0400
Received: from ozlabs.org ([203.10.76.45]:45257 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762605Ab3EDAoo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 May 2013 20:44:44 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: "H. Peter Anvin" <hpa@zytor.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "Linus Torvalds" <torvalds@linux-foundation.org>
Subject: Re: modpost command line still is a problem
In-Reply-To: <5182A850.5010905@zytor.com>
References: <5182A850.5010905@zytor.com>
User-Agent: Notmuch/0.15.2+81~gd2c8818 (http://notmuchmail.org) Emacs/23.4.1 (i686-pc-linux-gnu)
Date: Fri, 03 May 2013 23:01:06 +0930
Message-ID: <87mwscp4v9.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"H. Peter Anvin" <hpa@zytor.com> writes:

> At least as far as current linus, "make allmodconfig" still fails with
> O= in a sufficiently deep directory due to the modpost command line
> being too long.
>
> There was a bunch of talk about how to address that, but did anything
> ever come of it?
>
> 	-hpa

There were issues with merging my modules-next branch, but that should
contain the fixes.

Thanks,
Rusty.
