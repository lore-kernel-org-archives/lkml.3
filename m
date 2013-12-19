Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754713Ab3LSPHS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 10:07:18 -0500
Received: from merlin.infradead.org ([205.233.59.134]:54916 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753264Ab3LSPHP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 10:07:15 -0500
Date: Thu, 19 Dec 2013 08:07:01 -0700
From: Jens Axboe <axboe@kernel.dk>
To: Rashika Kheria <rashika.kheria@gmail.com>
Cc: linux-kernel@vger.kernel.org,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Ramprasad Chinthekindi <rchinthekindi@stec-inc.com>,
        Akhil Bhansali <abhansali@stec-inc.com>, josh@joshtriplett.org
Subject: Re: [PATCH 01/13] drivers: block: Mark the functions as static in
 skd_main.c
Message-ID: <20131219150701.GD30200@kernel.dk>
References: <f460591345e87defe53122cf056991c7f2eefa10.1387445396.git.rashika.kheria@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <f460591345e87defe53122cf056991c7f2eefa10.1387445396.git.rashika.kheria@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 19 2013, Rashika Kheria wrote:
> Mark functions skd_skmsg_state_to_str() and skd_skreq_state_to_str() as
> static in skd_main.c because they are not used outside this file.
> 
> This eliminates the following warnings in skd_main.c:
> drivers/block/skd_main.c:5272:13: warning: no previous prototype for ‘skd_skmsg_state_to_str’ [-Wmissing-prototypes]
> drivers/block/skd_main.c:5284:13: warning: no previous prototype for ‘skd_skreq_state_to_str’ [-Wmissing-prototypes]

Thanks, applied.

-- 
Jens Axboe

