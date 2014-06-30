Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753925AbaF3Prz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 11:47:55 -0400
Received: from mga11.intel.com ([192.55.52.93]:39813 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751302AbaF3Pry (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 11:47:54 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="358388816"
Message-ID: <1404143270.6841.2.camel@sauron.fi.intel.com>
Subject: Re: [PATCH] ubi: fix correct rb_tree node comparison in add_vol
From: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
Reply-To: artem.bityutskiy@linux.intel.com
To: Heiko Schocher <hs@denx.de>
Cc: linux-mtd@lists.infradead.org, Richard Weinberger <richard@nod.at>,
        David Woodhouse <dwmw2@infradead.org>,
        Brian Norris <computersforpeace@gmail.com>,
        Mike Snitzer <snitzer@redhat.com>, Wolfgang Denk <wd@denx.de>,
        linux-kernel@vger.kernel.org
Date: Mon, 30 Jun 2014 18:47:50 +0300
In-Reply-To: <1403594718-20595-1-git-send-email-hs@denx.de>
References: <1403594718-20595-1-git-send-email-hs@denx.de>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-2.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-06-24 at 09:25 +0200, Heiko Schocher wrote:
> Commit 604b592e6fd3c98f21435e1181ba7723ffc24715 ("UBI: fix rb_tree node comparison in add_map")
> 
> introduced problems with attaching ubi fastmap images,
> created with older kernel.

Changed the commit message to be a bit more reader-friendly and pushed
to linux-ubifs.git, thank you!

-- 
Best Regards,
Artem Bityutskiy

