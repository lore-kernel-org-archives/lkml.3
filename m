Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755000AbaHNWE2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2014 18:04:28 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:34271 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753318AbaHNWE1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2014 18:04:27 -0400
Date: Thu, 14 Aug 2014 15:04:25 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Akinobu Mita <akinobu.mita@gmail.com>
Cc: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Jeff Moyer <jmoyer@redhat.com>, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 0/3] implement readpages() for block device to optimize
 sequential read
Message-Id: <20140814150425.dfbb6c7eb7ab250e985dac28@linux-foundation.org>
In-Reply-To: <1407249514-20465-1-git-send-email-akinobu.mita@gmail.com>
References: <1407249514-20465-1-git-send-email-akinobu.mita@gmail.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue,  5 Aug 2014 23:38:31 +0900 Akinobu Mita <akinobu.mita@gmail.com> wrote:

> This patchset implements readpages() operation for block device by
> using mpage_readpages() which can create multipage BIOs instead of
> BIOs for each page and reduce system CPU time consumption.

Patchset is simple and straightforward enough.  But who the 
heck cares about the performance of buffered reads from /dev/XXX?
