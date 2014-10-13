Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754259AbaJMPhY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2014 11:37:24 -0400
Received: from mga09.intel.com ([134.134.136.24]:32486 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753797AbaJMPhW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2014 11:37:22 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,711,1406617200"; 
   d="scan'208";a="588088930"
Message-ID: <1413214637.7906.49.camel@sauron.fi.intel.com>
Subject: Re: [PATCH v3] mtd: ubi: Extend UBI layer debug/messaging
 capabilities
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Tanya Brokhman <tlinder@codeaurora.org>
Cc: linux-mtd@lists.infradead.org, linux-arm-msm@vger.kernel.org,
        David Woodhouse <dwmw2@infradead.org>,
        Brian Norris <computersforpeace@gmail.com>,
        Richard Weinberger <richard@nod.at>,
        open list <linux-kernel@vger.kernel.org>
Date: Mon, 13 Oct 2014 18:37:17 +0300
In-Reply-To: <1412593268-12377-1-git-send-email-tlinder@codeaurora.org>
References: <1412593268-12377-1-git-send-email-tlinder@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-4.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-10-06 at 14:01 +0300, Tanya Brokhman wrote:
> If there is more then one UBI device mounted, there is no way to
> distinguish between messages from different UBI devices.
> Add device number to all ubi layer message types.

Looks good to me, pushed to the master branch of the linux-ubifs.git
tree. Later, when the merge window is closed, I'll merge this patch to
the linux-next branch too.

Thanks!

--
Artem

