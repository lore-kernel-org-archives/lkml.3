Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965279AbaGOX1A (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 19:27:00 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:45755 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965214AbaGOX0z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 19:26:55 -0400
Date: Tue, 15 Jul 2014 16:26:54 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Mathias Krause <minipli@googlemail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Joe Perches <joe@perches.com>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/8] Mark literal strings in __init / __exit code
Message-Id: <20140715162654.9afca195c6c6410c72e61864@linux-foundation.org>
In-Reply-To: <1405176212-12175-1-git-send-email-minipli@googlemail.com>
References: <1405176212-12175-1-git-send-email-minipli@googlemail.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 12 Jul 2014 16:43:24 +0200 Mathias Krause <minipli@googlemail.com> wrote:

> This is v2 of the patch series initially posted here:
> 
>   https://lkml.org/lkml/2014/6/22/149

That was a useful overall description.  But it got lost in the
transition to v2 and is now out of date.

Please resurrect it, and maintain it.
