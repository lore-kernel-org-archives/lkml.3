Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753027AbaJTNv3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2014 09:51:29 -0400
Received: from mga14.intel.com ([192.55.52.115]:25037 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752536AbaJTNv2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2014 09:51:28 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="402946998"
Message-ID: <1413813074.7906.294.camel@sauron.fi.intel.com>
Subject: Re: [PATCH v4] mtd: ubi: Extend UBI layer debug/messaging
 capabilities
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Joe Perches <joe@perches.com>
Cc: Tanya Brokhman <tlinder@codeaurora.org>,
        ezequiel.garcia@free-electrons.com, linux-mtd@lists.infradead.org,
        linux-arm-msm@vger.kernel.org, David Woodhouse <dwmw2@infradead.org>,
        Brian Norris <computersforpeace@gmail.com>,
        Richard Weinberger <richard@nod.at>,
        open list <linux-kernel@vger.kernel.org>
Date: Mon, 20 Oct 2014 16:51:14 +0300
In-Reply-To: <1413302724.3269.18.camel@joe-AO725>
References: <1413296037-22346-1-git-send-email-tlinder@codeaurora.org>
	 <543D304C.5000607@codeaurora.org> <1413297205.3269.11.camel@joe-AO725>
	 <1413299231.7906.101.camel@sauron.fi.intel.com>
	 <1413302724.3269.18.camel@joe-AO725>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-4.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-10-14 at 09:05 -0700, Joe Perches wrote:
> It's pretty trivial when all the lines are already
> being touched.

OK, but then the same change should done in UBIFS, because it's
ubifs_msg() and so on macros are consistent with UBI macros. So I think
if this is done, then it is done separately for both UBI and UBIFS.

Artem.

