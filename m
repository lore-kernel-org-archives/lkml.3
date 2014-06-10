Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751909AbaFJLgE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 07:36:04 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:35877 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750788AbaFJLgC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 07:36:02 -0400
Date: Tue, 10 Jun 2014 04:35:40 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Ming Lei <tom.leiming@gmail.com>
Cc: Jens Axboe <axboe@fb.com>, Christoph Hellwig <hch@infradead.org>,
        Matias Bj??rling <m@bjorling.me>,
        Matthew Wilcox <willy@linux.intel.com>,
        Keith Busch <keith.busch@intel.com>,
        "Sam Bradshaw (sbradshaw)" <sbradshaw@micron.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-nvme <linux-nvme@lists.infradead.org>
Subject: Re: [PATCH v6] NVMe: conversion to blk-mq
Message-ID: <20140610113540.GA26195@infradead.org>
References: <1402057225-7312-1-git-send-email-m@bjorling.me>
 <1402057225-7312-2-git-send-email-m@bjorling.me>
 <CACVXFVOieM2cT4FFJhD9MecfCLBtE3AwjCpOeGGRUcmWnN=B=A@mail.gmail.com>
 <5395BFF2.2080402@fb.com>
 <20140609145944.GA30626@infradead.org>
 <5395D24D.9000306@fb.com>
 <CACVXFVNNm5PJ8g=QD5zm49kaqW_oKCM+utMz+qSd=3WfsE4U2g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACVXFVNNm5PJ8g=QD5zm49kaqW_oKCM+utMz+qSd=3WfsE4U2g@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 09, 2014 at 11:35:00PM +0800, Ming Lei wrote:
> 
> Use-after-free may cause duplicate completions.
> 
> BTW, is the scsi-mq patchset public now?

It always has been.  I've posted it fairly frequently to linux-scsi,
and git://git.infradead.org/users/hch/scsi.git always has the latest
code, with scsi-mq-wip.11 as the current iteration.
