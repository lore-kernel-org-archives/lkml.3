Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752098AbaAMX6R (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 18:58:17 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:53661 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751207AbaAMX6P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 18:58:15 -0500
Date: Mon, 13 Jan 2014 15:58:14 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Minchan Kim <minchan@kernel.org>
Cc: linux-kernel@vger.kernel.org, Nitin Gupta <ngupta@vflare.org>,
        Jerome Marchand <jmarchan@redhat.com>,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Subject: Re: [PATCH 4/7] zram: use atomic operation for stat
Message-Id: <20140113155814.07ab74c8f77179fc770a8e5f@linux-foundation.org>
In-Reply-To: <1389611942-15544-5-git-send-email-minchan@kernel.org>
References: <1389611942-15544-1-git-send-email-minchan@kernel.org>
	<1389611942-15544-5-git-send-email-minchan@kernel.org>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 13 Jan 2014 20:18:59 +0900 Minchan Kim <minchan@kernel.org> wrote:

> Some of fields in zram->stats are protected by zram->lock which
> is rather coarse-grained so let's use atomic operation without
> explict locking.

Confused.  The patch didn't remove any locking, so it made the code
slower.

