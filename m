Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754214AbaH2TO2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2014 15:14:28 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:45584 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753030AbaH2TO1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2014 15:14:27 -0400
Date: Fri, 29 Aug 2014 12:14:26 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Rob Jones <rob.jones@codethink.co.uk>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, jbaron@akamai.com,
        cl@linux-foundation.org, penberg@kernel.org, mpm@selenic.com,
        linux-kernel@codethink.co.uk
Subject: Re: [PATCH 0/4] Tidy up of modules using seq_open()
Message-Id: <20140829121426.4044f2a330f9d74fe37f7825@linux-foundation.org>
In-Reply-To: <1409328400-18212-1-git-send-email-rob.jones@codethink.co.uk>
References: <1409328400-18212-1-git-send-email-rob.jones@codethink.co.uk>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 29 Aug 2014 17:06:36 +0100 Rob Jones <rob.jones@codethink.co.uk> wrote:

> Many modules use seq_open() when seq_open_private() or
> __seq_open_private() would be more appropriate and result in
> simpler, cleaner code.
> 
> This patch sequence changes those instances in IPC, MM and LIB.

Looks good to me.

I can't begin to imagine why we added the global, exported-to-modules
seq_open_private() without bothering to document it, so any time you
feel like adding the missing kerneldoc...

And psize should have been size_t, ho hum.

