Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755914AbaKEPft (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 10:35:49 -0500
Received: from mga11.intel.com ([192.55.52.93]:12468 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755051AbaKEPfr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 10:35:47 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="411865722"
Message-ID: <1415201733.958.121.camel@sauron.fi.intel.com>
Subject: Re: [PATCH V6] UBI: Extend UBI layer debug/messaging capabilities
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Tanya Brokhman <tlinder@codeaurora.org>
Cc: linux-mtd@lists.infradead.org, linux-arm-msm@vger.kernel.org,
        David Woodhouse <dwmw2@infradead.org>,
        Brian Norris <computersforpeace@gmail.com>,
        Richard Weinberger <richard@nod.at>,
        open list <linux-kernel@vger.kernel.org>
Date: Wed, 05 Nov 2014 17:35:33 +0200
In-Reply-To: <1415023112-21704-1-git-send-email-tlinder@codeaurora.org>
References: <1415023112-21704-1-git-send-email-tlinder@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-4.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-11-03 at 15:58 +0200, Tanya Brokhman wrote:
> If there is more then one UBI device mounted, there is no way to
> distinguish between messages from different UBI devices.
> Add device number to all ubi layer message types.
> 
> The R/O block driver messages were replaced by pr_* since
> ubi_device structure is not used by it.
> 
> Amended a bit by Artem.
> 
> Signed-off-by: Tanya Brokhman <tlinder@codeaurora.org>
> Signed-off-by: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>

Oh, the entire patch-set again... this means we need to review it again!
Please, have a mercy! :-) It is huge! Please, send a small patch against
the one which I pushed already. Thanks!

Artem.

