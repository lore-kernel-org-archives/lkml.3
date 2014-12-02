Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753950AbaLBPPt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 10:15:49 -0500
Received: from mail-pd0-f170.google.com ([209.85.192.170]:36960 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753711AbaLBPPs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 10:15:48 -0500
Message-ID: <547DD7A1.3040405@kernel.dk>
Date: Tue, 02 Dec 2014 08:15:45 -0700
From: Jens Axboe <axboe@kernel.dk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: "Martin K. Petersen" <martin.petersen@oracle.com>,
        "Darrick J. Wong" <darrick.wong@oracle.com>
CC: linux-kernel@vger.kernel.org,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH v2] block: fix regression where bio_integrity_process
 uses wrong bio_vec iterator
References: <20141126014025.GD10050@birch.djwong.org> <yq161e2sgnl.fsf@sermon.lab.mkp.net>
In-Reply-To: <yq161e2sgnl.fsf@sermon.lab.mkp.net>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/25/2014 09:57 PM, Martin K. Petersen wrote:
>>>>>> "Darrick" == Darrick J Wong <darrick.wong@oracle.com> writes:
>
> Darrick> Therefore, teach bio_integrity_process() to use
> Darrick> bio_for_each_segment() to iterate the bio_vecs, since the
> Darrick> per-bio iterator tracks which bio_vecs are associated with that
> Darrick> particular bio.  The integrity handling code is effectively
> Darrick> part of the "driver" (it's not the bio owner), so it must use
> Darrick> the correct iterator function.
>
> Acked-by: Martin K. Petersen <martin.petersen@oracle.com>

Applied for 3.18.

-- 
Jens Axboe

