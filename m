Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754095Ab3EMHFe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 May 2013 03:05:34 -0400
Received: from mga09.intel.com ([134.134.136.24]:31322 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752190Ab3EMHFc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 May 2013 03:05:32 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,659,1363158000"; 
   d="scan'208";a="312515287"
Message-ID: <1368428882.5360.3.camel@sauron.fi.intel.com>
Subject: Re: [PATCH 3/8] mtd: use generic helper to set max_discard_sectors
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Namjae Jeon <linkinjeon@gmail.com>
Cc: dwmw2@infradead.org, axboe@kernel.dk, shli@kernel.org,
        Paul.Clements@steeleye.com, npiggin@kernel.dk, neilb@suse.de,
        cjb@laptop.org, adrian.hunter@intel.com, linux-mtd@lists.infradead.org,
        nbd-general@lists.sourceforge.net, linux-raid@vger.kernel.org,
        linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Namjae Jeon <namjae.jeon@samsung.com>,
        Vivek Trivedi <t.vivek@samsung.com>
Date: Mon, 13 May 2013 10:08:02 +0300
In-Reply-To: <1365860324-21295-1-git-send-email-linkinjeon@gmail.com>
References: <1365860324-21295-1-git-send-email-linkinjeon@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2013-04-13 at 22:38 +0900, Namjae Jeon wrote:
> From: Namjae Jeon <namjae.jeon@samsung.com>
> 
> It is better to use blk_queue_max_discard_sectors helper
> function to set max_discard_sectors as it checks
> max_discard_sectors upper limit UINT_MAX >> 9
> 
> similar issue was reported for mmc in below link
> https://lkml.org/lkml/2013/4/1/292

Pushed to l2-mtd.git, thanks!

-- 
Best Regards,
Artem Bityutskiy

