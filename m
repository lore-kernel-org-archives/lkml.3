Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753465Ab3KDPZM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Nov 2013 10:25:12 -0500
Received: from merlin.infradead.org ([205.233.59.134]:34889 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752785Ab3KDPZK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Nov 2013 10:25:10 -0500
Message-ID: <5277BC43.3070604@kernel.dk>
Date: Mon, 04 Nov 2013 08:24:51 -0700
From: Jens Axboe <axboe@kernel.dk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
CC: abhansali@stec-inc.com, jmoyer@redhat.com, kyungmin.park@samsung.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/14] skd: various fixes/cleanups
References: <1380547556-17719-1-git-send-email-b.zolnierkie@samsung.com> <1488977.iDESHezIxt@amdc1032>
In-Reply-To: <1488977.iDESHezIxt@amdc1032>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/04/2013 04:08 AM, Bartlomiej Zolnierkiewicz wrote:
> 
> Hi Jens,
> 
> Could you please take a look at this patchset? It has been posted
> a month ago and there has been no feedback from you.
> 
> Today I've noticed that you've recently done some changes in your
> for-3.13/drivers branch which seem to duplicate some of my work
> (especially commit "skd: rip out bio path") and conflict with my
> patchset. :(

I was holding it back, since I wanted to push it a release. But I think
we are in fairly good shape for 3.13. Would you care to resend it
against for-3.13/drivers?

-- 
Jens Axboe

