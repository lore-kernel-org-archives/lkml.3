Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754714AbaGVNtH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 09:49:07 -0400
Received: from mx1.redhat.com ([209.132.183.28]:64281 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752508AbaGVNtF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 09:49:05 -0400
From: Jeff Moyer <jmoyer@redhat.com>
To: Gu Zheng <guz.fnst@cn.fujitsu.com>
Cc: bcrl@kvack.org, axboe@kernel.dk, akpm@linux-foundation.org,
        linux-aio@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/4] aio: use iovec array rather than the single one
References: <1405996804-8262-1-git-send-email-guz.fnst@cn.fujitsu.com>
	<1405996804-8262-4-git-send-email-guz.fnst@cn.fujitsu.com>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Tue, 22 Jul 2014 09:48:50 -0400
In-Reply-To: <1405996804-8262-4-git-send-email-guz.fnst@cn.fujitsu.com> (Gu
	Zheng's message of "Tue, 22 Jul 2014 10:40:04 +0800")
Message-ID: <x49lhrl8px9.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gu Zheng <guz.fnst@cn.fujitsu.com> writes:

> use an iovec array rather than the single one, so that we can avoid
> to alloc more iovecs buffer in small(< 8) PREADV/PWRITEV cases.

It would be helpful to know what motivated this change and how you
tested it.

Thanks,
Jeff
