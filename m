Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751977AbaABPW4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jan 2014 10:22:56 -0500
Received: from mga02.intel.com ([134.134.136.20]:50788 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751631AbaABPWz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jan 2014 10:22:55 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,591,1384329600"; 
   d="scan'208";a="460739615"
Message-ID: <1388676172.25123.93.camel@sauron.fi.intel.com>
Subject: Re: [PATCH 1/1]  MTD: UBI:  avoid program operation on  NOR flash
 after erasure interrupted
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Qi Wang =?UTF-8?Q?=E7=8E=8B=E8=B5=B7?= "(qiwang)" 
	<qiwang@micron.com>
Cc: Adrian Hunter <adrian.hunter@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>
Date: Thu, 02 Jan 2014 17:22:52 +0200
In-Reply-To: <1388675460.25123.90.camel@sauron.fi.intel.com>
References: <71CF8D7F32C5C24C9CD1D0E02D52498A770B54B1@NTXXIAMBX02.xacn.micron.com>
	 <71CF8D7F32C5C24C9CD1D0E02D52498A770B68A8@NTXXIAMBX02.xacn.micron.com>
	 <71CF8D7F32C5C24C9CD1D0E02D52498A770B6F77@NTXXIAMBX02.xacn.micron.com>
	 <71CF8D7F32C5C24C9CD1D0E02D52498A770B79C8@NTXXIAMBX02.xacn.micron.com>
	 <71CF8D7F32C5C24C9CD1D0E02D52498A770B8611@NTXXIAMBX02.xacn.micron.com>
	 <71CF8D7F32C5C24C9CD1D0E02D52498A770BA389@NTXXIAMBX02.xacn.micron.com>
	 <1388675460.25123.90.camel@sauron.fi.intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.5 (3.8.5-2.fc19) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-01-02 at 17:11 +0200, Artem Bityutskiy wrote:
> Anyway, I did not respond for long time, so I decided to do all these
> modifications myself. Could you please review and test the below patch,
> which is also attached. I did not compile it even. If there are issues,
> just fix-it up and send the the fix or the fixed version. If it is OK,
> give me your "Tested-by:" please. Thanks!

Actually, for convenience, I've pushed this patch to the 'qi' branch of
the 'linux-ubifs' git tree:

git://git.infradead.org/ubifs-2.6.git

-- 
Best Regards,
Artem Bityutskiy

