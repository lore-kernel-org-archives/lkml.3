Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966227Ab3DQSOX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Apr 2013 14:14:23 -0400
Received: from na3sys010aog108.obsmtp.com ([74.125.245.84]:40117 "HELO
	na3sys010aog108.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S965858Ab3DQSOV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Apr 2013 14:14:21 -0400
MIME-Version: 1.0
In-Reply-To: <516EE4BD.3000200@infradead.org>
References: <20130417170450.5dd6e5f450de4d5bf197d997@canb.auug.org.au> <516EE4BD.3000200@infradead.org>
From: Roland Dreier <roland@purestorage.com>
Date: Wed, 17 Apr 2013 11:13:58 -0700
Message-ID: <CAL1RGDWhij_HwACeGH-=eXKrtTG67rKtJPvtSQrEWQsSYR7gAQ@mail.gmail.com>
Subject: Re: linux-next: Tree for Apr 17 (infiniband/rdma)
To: Randy Dunlap <rdunlap@infradead.org>,
        "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 17, 2013 at 11:06 AM, Randy Dunlap <rdunlap@infradead.org> wrote:
> on x86_64:
>
> drivers/built-in.o: In function `isert_free_np':
> ib_isert.c:(.text+0x6e8a77): undefined reference to `rdma_destroy_id'
> drivers/built-in.o: In function `isert_conn_setup_qp':
> ib_isert.c:(.text+0x6e9038): undefined reference to `rdma_create_qp'

Nic, I think isert needs a "depends on INFINIBAND_ADDR_TRANS" to avoid this.
(this is coming from the SCSI target tree, not the InfiniBand/RDMA tree)

 - R.
