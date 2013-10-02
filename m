Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754074Ab3JBUjA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Oct 2013 16:39:00 -0400
Received: from c60.cesmail.net ([216.154.195.49]:10572 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752949Ab3JBUi7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Oct 2013 16:38:59 -0400
X-Greylist: delayed 581 seconds by postgrey-1.27 at vger.kernel.org; Wed, 02 Oct 2013 16:38:59 EDT
Date: Wed, 2 Oct 2013 16:29:12 -0400
From: Pavel Roskin <proski@gnu.org>
To: David Herrmann <dh.herrmann@gmail.com>
Cc: linux-kernel@vger.kernel.org, Tom Gundersen <teg@jklm.no>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@kernel.org>,
        x86@kernel.org
Subject: Re: [PATCH] x86: sysfb: mark simplefb resources as BUSY
Message-ID: <20131002162912.25cb7f4a@IRBT4585>
In-Reply-To: <1380724864-1757-1-git-send-email-dh.herrmann@gmail.com>
References: <1380724864-1757-1-git-send-email-dh.herrmann@gmail.com>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed,  2 Oct 2013 16:41:04 +0200
David Herrmann <dh.herrmann@gmail.com> wrote:

> Tested-by: Pavel Roskin <proski@gnu.org>

Tested indeed, on ThinkPad W530 with 32-bit and 64-bit kernels with
Intel and NVidia graphics enabled.

> Sorry for the delay, but I was in the US for the last 2 weeks and
> this is really no major issue, just suppresses a warning that says
> "Your kernel is fine".

It shows a stack trace, so it might confuse (and has confused) users
into thinking that it's a more important issue than it is.

> Anyhow, thanks to Tom and Pavel for reporting
> and testing this! This is targeted at 3.12-rc4 as bugfix. I think
> it's still early/mid rc-stage and is a one-line patch so it should be
> fine, right?

I second this.

-- 
Regards,
Pavel Roskin
