Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752578AbaL3MpS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Dec 2014 07:45:18 -0500
Received: from bombadil.infradead.org ([198.137.202.9]:44220 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751580AbaL3MpQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Dec 2014 07:45:16 -0500
Date: Tue, 30 Dec 2014 04:45:11 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Chen Gang <gang.chen.5i5j@gmail.com>
Cc: megaraidlinux@lsi.com, JBottomley@parallels.com,
        Sumit Saxena <sumit.saxena@avagotech.com>, linux-scsi@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] drivers: scsi: megaraid: Add
 "megaraid_sas_internal.h" for internal shared functions using
Message-ID: <20141230124511.GB24088@infradead.org>
References: <548DB542.7000400@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <548DB542.7000400@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 15, 2014 at 12:05:22AM +0800, Chen Gang wrote:
> For shared inline functions crossed source files, better to let it as
> "static inline" in a header file. For extern functions, better to
> declare them in header file.


This one doesn't apply.
