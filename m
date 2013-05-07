Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757932Ab3EGMCM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 08:02:12 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:53785 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757117Ab3EGMCM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 08:02:12 -0400
Date: Tue, 7 May 2013 13:02:01 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>,
        Yoshinori Sato <ysato@users.sourceforge.jp>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] h8300: Hardcode symbol prefixes in asm sources
Message-ID: <20130507120201.GP25399@ZenIV.linux.org.uk>
References: <1367920320-18382-1-git-send-email-geert@linux-m68k.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1367920320-18382-1-git-send-email-geert@linux-m68k.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 07, 2013 at 11:52:00AM +0200, Geert Uytterhoeven wrote:
>  arch/h8300/kernel/syscalls.S                     |  646 +++++++++++-----------

NAK on this part - either turn it into array initialized in something.c,
or at least do something like
#define CALL(x)	.long _##x
and use that to fill the damn thing.
