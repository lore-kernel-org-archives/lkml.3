Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751917AbaKJXVg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 18:21:36 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:44996 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751398AbaKJXVf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 18:21:35 -0500
Date: Mon, 10 Nov 2014 15:21:35 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Faisal Abbas <90.abbasfaisal@gmail.com>
Cc: dhowells@redhat.com, fabf@skynet.be, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] FRV: Wire up new syscalls
Message-Id: <20141110152135.17dde96612eb81d8725967a4@linux-foundation.org>
In-Reply-To: <1415550363-6172-1-git-send-email-90.abbasfaisal@gmail.com>
References: <1415550363-6172-1-git-send-email-90.abbasfaisal@gmail.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun,  9 Nov 2014 21:26:03 +0500 Faisal Abbas <90.abbasfaisal@gmail.com> wrote:

> Compiling source tree for FRV generates following warnings so wire these syscalls up.
> 
> <stdin>:1187:2: warning: #warning syscall recvmmsg not implemented [-Wcpp]
> <stdin>:1190:2: warning: #warning syscall fanotify_init not implemented [-Wcpp]

It's David's call, but I'd be reluctant to make changes like this
unless it's shown that each of these syscalls actually works correctly
on FRV.

