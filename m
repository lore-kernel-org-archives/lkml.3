Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756127AbaISKrl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2014 06:47:41 -0400
Received: from mga02.intel.com ([134.134.136.20]:47960 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756041AbaISKrk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2014 06:47:40 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,554,1406617200"; 
   d="scan'208";a="605324999"
Message-ID: <1411123647.28850.138.camel@sauron.fi.intel.com>
Subject: Re: [PATCH] UBI: Fix possible deadlock in erase_worker()
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Richard Weinberger <richard@nod.at>
Cc: dwmw2@infradead.org, computersforpeace@gmail.com,
        linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Date: Fri, 19 Sep 2014 13:47:27 +0300
In-Reply-To: <541BFB6D.3040903@nod.at>
References: <1410853702-11616-1-git-send-email-richard@nod.at>
	 <1410946526.28850.120.camel@sauron.fi.intel.com> <541BFB6D.3040903@nod.at>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-2.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-09-19 at 11:46 +0200, Richard Weinberg
> Or we apply "[PATCH 1/2] UBI: Call worker functions without work_sem held". :)

But I explained in the other e-mail that the semaphore is needed, and
why.

-- 
Best Regards,
Artem Bityutskiy

