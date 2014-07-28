Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752730AbaG1QIx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 12:08:53 -0400
Received: from mga14.intel.com ([192.55.52.115]:12222 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751999AbaG1QIt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 12:08:49 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="365202831"
Message-ID: <1406563726.23376.33.camel@sauron.fi.intel.com>
Subject: Re: [PATCH] UBI: ubi_wl_flush(): Use list_for_each_entry_safe()
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Richard Weinberger <richard@nod.at>
Cc: dwmw2@infradead.org, computersforpeace@gmail.com,
        linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org
Date: Mon, 28 Jul 2014 19:08:46 +0300
In-Reply-To: <1406446548-5790-1-git-send-email-richard@nod.at>
References: <1406446548-5790-1-git-send-email-richard@nod.at>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-2.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2014-07-27 at 09:35 +0200, Richard Weinberger wrote:
> Use the _safe variant because we're iterating over
> a list where items get deleted and freed.
> 
> Signed-off-by: Richard Weinberger <richard@nod.at>

Pushed to linux-ubifs.git, thanks!

-- 
Best Regards,
Artem Bityutskiy

