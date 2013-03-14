Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757342Ab3CNMRz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 08:17:55 -0400
Received: from mga09.intel.com ([134.134.136.24]:28137 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756156Ab3CNMRy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 08:17:54 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,844,1355126400"; 
   d="scan'208";a="302004704"
Message-ID: <1363263529.11441.109.camel@sauron.fi.intel.com>
Subject: Re: MTD : Kernel oops when remounting ubifs as read/write
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Mark Jackson <mpfj-list@mimc.co.uk>
Cc: "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>, adrian.hunter@intel.com
Date: Thu, 14 Mar 2013 14:18:49 +0200
In-Reply-To: <5141BC63.6060501@mimc.co.uk>
References: <5134CEF9.5070502@mimc.co.uk>
	    <1363087506.3348.62.camel@sauron.fi.intel.com>
	    <51405F3A.3090901@mimc.co.uk>
	   <1363252425.11441.94.camel@sauron.fi.intel.com>
	   <51419E3A.8030007@mimc.co.uk>
	  <1363257009.11441.97.camel@sauron.fi.intel.com>
	  <5141B154.6050504@mimc.co.uk>
	 <1363260202.11441.108.camel@sauron.fi.intel.com>
	 <5141BC63.6060501@mimc.co.uk>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.3 (3.6.3-2.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-03-14 at 12:02 +0000, Mark Jackson wrote:
> But there's also a call to crc with a size of 122880 bytes, and that's
> when the oops occurs.
> 
This is when we do the atomic LEB change.

> Is this size larger than the allocated buffer ?

I believe so.

-- 
Best Regards,
Artem Bityutskiy

