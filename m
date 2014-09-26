Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755681AbaIZKqQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 06:46:16 -0400
Received: from mga03.intel.com ([134.134.136.65]:23408 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755053AbaIZKqN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 06:46:13 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,604,1406617200"; 
   d="scan'208";a="609023773"
Message-ID: <1411728368.23429.64.camel@sauron.fi.intel.com>
Subject: Re: [PATCH 1/3] UBI: ubi_eba_read_leb: Remove in vain variable
 assignment
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Richard Weinberger <richard@nod.at>
Cc: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org
Date: Fri, 26 Sep 2014 13:46:08 +0300
In-Reply-To: <1411375536-20067-1-git-send-email-richard@nod.at>
References: <1411375536-20067-1-git-send-email-richard@nod.at>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-2.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-09-22 at 10:45 +0200, Richard Weinberger wrote:
> There is no need to set err, it will be overwritten in any case
> later at:
>         if (scrub)
>                 err = ubi_wl_scrub_peb(ubi, pnum);
> 
> Signed-off-by: Richard Weinberger <richard@nod.at>

Pushed the first 2 patches, thanks!

-- 
Best Regards,
Artem Bityutskiy

