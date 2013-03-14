Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757534Ab3CNMWj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 08:22:39 -0400
Received: from mga01.intel.com ([192.55.52.88]:60712 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757259Ab3CNMWh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 08:22:37 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,844,1355126400"; 
   d="scan'208";a="302730278"
Message-ID: <1363263812.11441.112.camel@sauron.fi.intel.com>
Subject: Re: MTD : Kernel oops when remounting ubifs as read/write
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Mark Jackson <mpfj-list@mimc.co.uk>
Cc: "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>, adrian.hunter@intel.com
Date: Thu, 14 Mar 2013 14:23:32 +0200
In-Reply-To: <1363263529.11441.109.camel@sauron.fi.intel.com>
References: <5134CEF9.5070502@mimc.co.uk>
	 <1363087506.3348.62.camel@sauron.fi.intel.com>
	 <51405F3A.3090901@mimc.co.uk>
	 <1363252425.11441.94.camel@sauron.fi.intel.com>
	 <51419E3A.8030007@mimc.co.uk>
	 <1363257009.11441.97.camel@sauron.fi.intel.com>
	 <5141B154.6050504@mimc.co.uk>
	 <1363260202.11441.108.camel@sauron.fi.intel.com>
	 <5141BC63.6060501@mimc.co.uk>
	 <1363263529.11441.109.camel@sauron.fi.intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.3 (3.6.3-2.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-03-14 at 14:18 +0200, Artem Bityutskiy wrote:
> > Is this size larger than the allocated buffer ?
> 
> I believe so.

Err, I mean, the buffer is large enough. I do not believe there is a
stupid bug like too small buffer. This code has worked for years and I
do not think it was changes much.

The oops may be cause by memory corruption - some of your drivers may
corrupt memory. You need to spend more time debugging this carefully.

Do you have fastmap UBI feature enabled?

-- 
Best Regards,
Artem Bityutskiy

