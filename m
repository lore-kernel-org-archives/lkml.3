Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753315AbaAGQWS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jan 2014 11:22:18 -0500
Received: from mail-la0-f54.google.com ([209.85.215.54]:46961 "EHLO
	mail-la0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752967AbaAGQVY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jan 2014 11:21:24 -0500
MIME-Version: 1.0
In-Reply-To: <1387831171-5264-4-git-send-email-jack@suse.cz>
References: <1387831171-5264-1-git-send-email-jack@suse.cz>
	<1387831171-5264-4-git-send-email-jack@suse.cz>
Date: Tue, 7 Jan 2014 17:21:22 +0100
Message-ID: <CAFTL4hwVLR25fUyyKzFQ1LXjEk+vV2r27YNdhH6s0T5EttnvBA@mail.gmail.com>
Subject: Re: [PATCH 3/9] kernel: use lockless list for smp_call_function_single()
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Jan Kara <jack@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>, Petr Mladek <pmladek@suse.cz>,
        Steven Rostedt <rostedt@goodmis.org>,
        LKML <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@lst.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/12/23 Jan Kara <jack@suse.cz>:
> From: Christoph Hellwig <hch@lst.de>
>
> Make smp_call_function_single and friends more efficient by using
> a lockless list.
>
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Signed-off-by: Jan Kara <jack@suse.cz>

FWIW, I really like that patch.

Reviewed-by: Frederic Weisbecker <fweisbec@gmail.com>
