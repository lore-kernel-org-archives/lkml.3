Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753573AbaGMNZD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jul 2014 09:25:03 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:36660 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753380AbaGMNY4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jul 2014 09:24:56 -0400
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] block: provide compat ioctl for BLKZEROOUT
From: "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
References: <alpine.LRH.2.02.1407021244360.20183@file01.intranet.prod.int.rdu2.redhat.com>
Date: Sun, 13 Jul 2014 09:24:49 -0400
In-Reply-To: <alpine.LRH.2.02.1407021244360.20183@file01.intranet.prod.int.rdu2.redhat.com>
	(Mikulas Patocka's message of "Wed, 2 Jul 2014 12:46:23 -0400 (EDT)")
Message-ID: <yq1tx6l1jdq.fsf@sermon.lab.mkp.net>
User-Agent: Gnus/5.130012 (Ma Gnus v0.12) Emacs/24.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Mikulas" == Mikulas Patocka <mpatocka@redhat.com> writes:

Mikulas> This patch provides the compat BLKZEROOUT ioctl. The argument
Mikulas> is a pointer to two uint64_t values, so there is no need to
Mikulas> translate it.

Acked-by: Martin K. Petersen <martin.petersen@oracle.com>

-- 
Martin K. Petersen	Oracle Linux Engineering
