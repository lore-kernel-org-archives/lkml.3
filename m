Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932478AbaISXAf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2014 19:00:35 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:57082 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932443AbaISXAe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2014 19:00:34 -0400
Date: Fri, 19 Sep 2014 16:00:32 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Fabian Frederick <fabf@skynet.be>
Cc: linux-kernel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>,
        Joe Perches <joe@perches.com>
Subject: Re: [PATCH V3 RESEND] SYSV: logging update
Message-Id: <20140919160032.5863df2729d42df7c0b58825@linux-foundation.org>
In-Reply-To: <1410642756-24237-1-git-send-email-fabf@skynet.be>
References: <1410642756-24237-1-git-send-email-fabf@skynet.be>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 13 Sep 2014 23:12:36 +0200 Fabian Frederick <fabf@skynet.be> wrote:

> -use current logging functions
> -replace no level printk by pr_err
> -add debug.c / sysv_err function to include sb->s_id
> -use pr_fmt with standard KBUILD_MODNAME ": "
> -use __builtin_return_address to display function name
> logging format is now:
> sysv: (sb->s_id) sysv_fill_super [sysv]: msg

Is this patch tested?
