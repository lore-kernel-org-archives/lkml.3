Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932099AbaJTXMV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2014 19:12:21 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:57737 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753858AbaJTXMT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2014 19:12:19 -0400
Date: Mon, 20 Oct 2014 16:12:19 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Richard Weinberger <richard@nod.at>
Cc: linux-fsdevel@vger.kernel.org, ocfs2-devel@oss.oracle.com,
        linux-kernel@vger.kernel.org, Mark Fasheh <mfasheh@suse.com>
Subject: Re: [Ocfs2-devel] [PATCH 2/2] ocfs2: Fix d_splice_alias() return
 code checking
Message-Id: <20141020161219.e68870b37a4a45dbf1e89db8@linux-foundation.org>
In-Reply-To: <1413715184-30196-2-git-send-email-richard@nod.at>
References: <1413715184-30196-1-git-send-email-richard@nod.at>
	<1413715184-30196-2-git-send-email-richard@nod.at>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 19 Oct 2014 12:39:44 +0200 Richard Weinberger <richard@nod.at> wrote:

> d_splice_alias() can return a valid dentry, NULL or an ERR_PTR.
> Currently the code checks not for ERR_PTR and my oops in
> ocfs2_dentry_attach_lock().

It's unclear what the second sentence is trying to tell us.  The patch
fixes an oops?  If so, a copy of the trace would be useful, as would an
explanation of why it occurred.  If not, I'm all confused.

