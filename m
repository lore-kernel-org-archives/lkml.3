Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757307Ab3GEKnM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jul 2013 06:43:12 -0400
Received: from mail-ie0-f169.google.com ([209.85.223.169]:45876 "EHLO
	mail-ie0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757207Ab3GEKnL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jul 2013 06:43:11 -0400
MIME-Version: 1.0
In-Reply-To: <20130704235313.GP4165@ZenIV.linux.org.uk>
References: <1372971797-23518-1-git-send-email-artagnon@gmail.com>
 <1372971797-23518-2-git-send-email-artagnon@gmail.com> <20130704235313.GP4165@ZenIV.linux.org.uk>
From: Ramkumar Ramachandra <artagnon@gmail.com>
Date: Fri, 5 Jul 2013 16:12:30 +0530
Message-ID: <CALkWK0mcK13RiVjNCrgwEaaL3nBZ1W0R5+cHAhbqiOmRE4UjAg@mail.gmail.com>
Subject: Re: [PATCH 1/3] arch/um/Makefile: remove dead code
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: LKML <linux-kernel@vger.kernel.org>, Richard Weinberger <richard@nod.at>,
        Jeff Dike <jdike@addtoit.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Al Viro wrote:
> [...]
> IOW, any make variable (== macro in POSIX quote above) can be explicitly
> set in make(1) command line in form name=value and in that case nothing in
> makefile(s) can change its value.  It's true for GNU make, it's true for
> BSD make and it's been true for historical Unix make since its introduction
> in v7.

Thanks Al, the education is much appreciated.  I always thought =
would override it, and ?= was for default value.
