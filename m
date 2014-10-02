Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753290AbaJBQ5v (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2014 12:57:51 -0400
Received: from mx1.redhat.com ([209.132.183.28]:34339 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752912AbaJBQ5r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2014 12:57:47 -0400
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 7.3 \(1878.6\))
Subject: Re: [PATCH] dm-log-userspace: fix memory leak on failure path in dm_ulog_tfr_init()
From: Brassow Jonathan <jbrassow@redhat.com>
In-Reply-To: <1412197115-32593-1-git-send-email-khoroshilov@ispras.ru>
Date: Thu, 2 Oct 2014 11:57:31 -0500
Cc: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>,
        dm-devel@redhat.com, Neil Brown <neilb@suse.de>,
        linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org,
        ldv-project@linuxtesting.org
Content-Transfer-Encoding: 7bit
Message-Id: <FEE6E0C5-985D-4DF1-AC42-8F4E0849195A@redhat.com>
References: <1412197115-32593-1-git-send-email-khoroshilov@ispras.ru>
To: Alexey Khoroshilov <khoroshilov@ispras.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Oct 1, 2014, at 3:58 PM, Alexey Khoroshilov <khoroshilov@ispras.ru> wrote:

> If cn_add_callback() fails in dm_ulog_tfr_init(), it does not
> deallocate prealloced memory but calls cn_del_callback().
> It looks like a misprint.
> 
> Found by Linux Driver Verification project (linuxtesting.org).
> 
> Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>

Signed-off-by: Jonathan Brassow <jbrassow@redhat.com>

