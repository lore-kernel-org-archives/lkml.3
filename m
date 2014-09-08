Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753177AbaIHK0x (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 06:26:53 -0400
Received: from mga09.intel.com ([134.134.136.24]:8917 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752986AbaIHK0w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 06:26:52 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,486,1406617200"; 
   d="scan'208";a="599593010"
Message-ID: <1410172009.10764.135.camel@sauron.fi.intel.com>
Subject: Re: [PATCH][V2] UBI: block: fix dereference on uninitialized dev
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
Cc: Colin King <colin.king@canonical.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Brian Norris <computersforpeace@gmail.com>,
        linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org
Date: Mon, 08 Sep 2014 13:26:49 +0300
In-Reply-To: <20140821191246.GA13322@arch.cereza>
References: <1408526378-12972-1-git-send-email-colin.king@canonical.com>
	 <20140821191246.GA13322@arch.cereza>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-2.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-08-21 at 16:12 -0300, Ezequiel Garcia wrote:
> On 20 Aug 10:19 AM, Colin King wrote:
> > From: Colin Ian King <colin.king@canonical.com>
> > 
> > commit 4df38926f337 ("UBI: block: Avoid disk size integer overflow")
> > introduced a dereference on dev (which is not initialized at that
> > point) when printing a warning message.  Re-order disk_capacity check
> > after the dev is found.
> > 
> > Found by cppcheck:
> >  [drivers/mtd/ubi/block.c:509]: (error) Uninitialized variable: dev
> > 
> > Signed-off-by: Colin Ian King <colin.king@canonical.com>
> 
> Acked-by: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>

Do we want to have this patch in @stable?

-- 
Best Regards,
Artem Bityutskiy

