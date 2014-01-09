Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755532AbaAIQ3B (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jan 2014 11:29:01 -0500
Received: from mga09.intel.com ([134.134.136.24]:60823 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753977AbaAIQ2n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jan 2014 11:28:43 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,631,1384329600"; 
   d="scan'208";a="464195173"
Message-ID: <1389284901.2259.144.camel@sauron.fi.intel.com>
Subject: Re: [PATCH 1/1]  MTD: UBI:  avoid program operation on  NOR flash
 after erasure interrupted
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Qi Wang =?UTF-8?Q?=E7=8E=8B=E8=B5=B7?= "(qiwang)" 
	<qiwang@micron.com>
Cc: Adrian Hunter <adrian.hunter@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>
Date: Thu, 09 Jan 2014 18:28:21 +0200
In-Reply-To: <71CF8D7F32C5C24C9CD1D0E02D52498A770C7770@NTXXIAMBX02.xacn.micron.com>
References: <71CF8D7F32C5C24C9CD1D0E02D52498A770B54B1@NTXXIAMBX02.xacn.micron.com>
	 <71CF8D7F32C5C24C9CD1D0E02D52498A770B68A8@NTXXIAMBX02.xacn.micron.com>
	 <71CF8D7F32C5C24C9CD1D0E02D52498A770B6F77@NTXXIAMBX02.xacn.micron.com>
	 <71CF8D7F32C5C24C9CD1D0E02D52498A770B79C8@NTXXIAMBX02.xacn.micron.com>
	 <71CF8D7F32C5C24C9CD1D0E02D52498A770B8611@NTXXIAMBX02.xacn.micron.com>
	 <71CF8D7F32C5C24C9CD1D0E02D52498A770BA389@NTXXIAMBX02.xacn.micron.com>
	 <1388675460.25123.90.camel@sauron.fi.intel.com>
	 <1388676172.25123.93.camel@sauron.fi.intel.com>
	 <71CF8D7F32C5C24C9CD1D0E02D52498A770BA889@NTXXIAMBX02.xacn.micron.com>
	 <1388728253.25123.98.camel@sauron.fi.intel.com>
	  <71CF8D7F32C5C24C9CD1D0E02D52498A770C7770@NTXXIAMBX02.xacn.micron.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.5 (3.8.5-2.fc19) 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-01-09 at 01:35 +0000, Qi Wang 王起 (qiwang) wrote:
> Hi Artem:
> Do you have any suggestion for my modification?
> Other code I think it is ok.

It is taken and pushed out. Thanks!

-- 
Best Regards,
Artem Bityutskiy

