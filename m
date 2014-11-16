Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755066AbaKPCr4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Nov 2014 21:47:56 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:48303 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754857AbaKPCry (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Nov 2014 21:47:54 -0500
Date: Sun, 16 Nov 2014 02:47:52 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Ionut Alexa <ionut.m.alexa@gmail.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kernel:signal.c Fix coding style errors and warnings.
Message-ID: <20141116024752.GP7996@ZenIV.linux.org.uk>
References: <1415980615-12345-1-git-send-email-ionut.m.alexa@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1415980615-12345-1-git-send-email-ionut.m.alexa@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 14, 2014 at 05:56:55PM +0200, Ionut Alexa wrote:
>     Fix various coding style errors and warnings as:
>         - space before tabs
>         - exiting a function from different points (else after return
>           ..)

How the hell is that goto any better than plain return?  Because some
moronic script^W^Wholy oracle says so?
