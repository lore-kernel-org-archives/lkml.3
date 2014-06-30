Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755764AbaF3P4c (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 11:56:32 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:22261 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755715AbaF3P43 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 11:56:29 -0400
To: Gu Zheng <guz.fnst@cn.fujitsu.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Jens <axboe@kernel.dk>,
        linux-kernel <linux-kernel@vger.kernel.org>, Kent <kmo@daterainc.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFC PATCH] bio-integrity: add "bip_max_vcnt" into struct bio_integrity_payload
From: "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
References: <53AD4385.8080105@cn.fujitsu.com>
	<yq1fvin9uje.fsf@sermon.lab.mkp.net> <53B0DBE2.9030300@cn.fujitsu.com>
Date: Mon, 30 Jun 2014 11:56:18 -0400
In-Reply-To: <53B0DBE2.9030300@cn.fujitsu.com> (Gu Zheng's message of "Mon, 30
	Jun 2014 11:39:14 +0800")
Message-ID: <yq1zjgu8k7x.fsf@sermon.lab.mkp.net>
User-Agent: Gnus/5.130012 (Ma Gnus v0.12) Emacs/24.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Gu" == Gu Zheng <guz.fnst@cn.fujitsu.com> writes:

Gu> Please refer to bio_kmalloc()--alloc bio via kmalloc. 

OK, missed that one because it was in bio.h.

In that case we absolutely need your patch.

Acked-by: Martin K. Petersen <martin.petersen@oracle.com>

-- 
Martin K. Petersen	Oracle Linux Engineering
