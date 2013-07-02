Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753359Ab3GBICa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jul 2013 04:02:30 -0400
Received: from merlin.infradead.org ([205.233.59.134]:39759 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750851Ab3GBICY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jul 2013 04:02:24 -0400
Date: Tue, 2 Jul 2013 10:02:15 +0200
From: Jens Axboe <axboe@kernel.dk>
To: Yijing Wang <wangyijing@huawei.com>
Cc: Mike Miller <mike.miller@hp.com>, linux-kernel@vger.kernel.org,
        Jiri Kosina <jkosina@suse.cz>, iss_storagedev@hp.com
Subject: Re: [PATCH 5/9] cciss: rework pci pm related code for simplification
Message-ID: <20130702080215.GT32428@kernel.dk>
References: <1371543553-13064-1-git-send-email-wangyijing@huawei.com>
 <51D23169.1070405@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51D23169.1070405@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 02 2013, Yijing Wang wrote:
> Hi Jens,
>    Sorry to disturb you, do you have any comments for this patch?

Looks fine to me, was waiting for Stephen/Mike to ack it and I'll pick
it up.

-- 
Jens Axboe

