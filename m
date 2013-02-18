Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758231Ab3BSICq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 03:02:46 -0500
Received: from ozlabs.org ([203.10.76.45]:51888 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758010Ab3BSICm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 03:02:42 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Borislav Petkov <bp@alien8.de>, LKML <linux-kernel@vger.kernel.org>
Cc: Borislav Petkov <bp@suse.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH] param, charp: Cache val length
In-Reply-To: <1361178750-17915-1-git-send-email-bp@alien8.de>
References: <1361178750-17915-1-git-send-email-bp@alien8.de>
User-Agent: Notmuch/0.14 (http://notmuchmail.org) Emacs/23.4.1 (i686-pc-linux-gnu)
Date: Mon, 18 Feb 2013 21:54:22 +1030
Message-ID: <87txp9j255.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Borislav Petkov <bp@alien8.de> writes:
> From: Borislav Petkov <bp@suse.de>
>
> ... instead of doing strlen twice.

I'm delighted with your enthusiasm for making trivial changes, but I
have trouble sharing in it.

In this case, it's so marginal that I'll leave the status quo.

Thanks,
Rusty.
