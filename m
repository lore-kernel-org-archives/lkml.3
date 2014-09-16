Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754058AbaIPPZI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 11:25:08 -0400
Received: from mga01.intel.com ([192.55.52.88]:58018 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753277AbaIPPZF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 11:25:05 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,534,1406617200"; 
   d="scan'208";a="600416980"
Message-ID: <1410880907.28850.50.camel@sauron.fi.intel.com>
Subject: Re: [PATCH] UBI: add missing kmem_cache_free() in process_pool_aeb
 error path
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Richard Genoud <richard.genoud@gmail.com>
Cc: Richard Weinberger <richard@nod.at>, linux-mtd@lists.infradead.org,
        linux-kernel@vger.kernel.org
Date: Tue, 16 Sep 2014 18:21:47 +0300
In-Reply-To: <1410265519-25111-1-git-send-email-richard.genoud@gmail.com>
References: <1410265519-25111-1-git-send-email-richard.genoud@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-2.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-09-09 at 14:25 +0200, Richard Genoud wrote:
> I ran into this error after a ubiupdatevol, because I forgot to backport
> e9110361a9a4 UBI: fix the volumes tree sorting criteria.

Pushed, thanks!

-- 
Best Regards,
Artem Bityutskiy

