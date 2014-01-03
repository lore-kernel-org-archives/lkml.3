Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752448AbaACFvG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jan 2014 00:51:06 -0500
Received: from mga14.intel.com ([143.182.124.37]:60733 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750753AbaACFvD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jan 2014 00:51:03 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,595,1384329600"; 
   d="scan'208";a="453096519"
Message-ID: <1388728253.25123.98.camel@sauron.fi.intel.com>
Subject: Re: [PATCH 1/1]  MTD: UBI:  avoid program operation on  NOR flash
 after erasure interrupted
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Qi Wang =?UTF-8?Q?=E7=8E=8B=E8=B5=B7?= "(qiwang)" 
	<qiwang@micron.com>
Cc: Adrian Hunter <adrian.hunter@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>
Date: Fri, 03 Jan 2014 07:50:53 +0200
In-Reply-To: <71CF8D7F32C5C24C9CD1D0E02D52498A770BA889@NTXXIAMBX02.xacn.micron.com>
References: <71CF8D7F32C5C24C9CD1D0E02D52498A770B54B1@NTXXIAMBX02.xacn.micron.com>
	 <71CF8D7F32C5C24C9CD1D0E02D52498A770B68A8@NTXXIAMBX02.xacn.micron.com>
	 <71CF8D7F32C5C24C9CD1D0E02D52498A770B6F77@NTXXIAMBX02.xacn.micron.com>
	 <71CF8D7F32C5C24C9CD1D0E02D52498A770B79C8@NTXXIAMBX02.xacn.micron.com>
	 <71CF8D7F32C5C24C9CD1D0E02D52498A770B8611@NTXXIAMBX02.xacn.micron.com>
	 <71CF8D7F32C5C24C9CD1D0E02D52498A770BA389@NTXXIAMBX02.xacn.micron.com>
	 <1388675460.25123.90.camel@sauron.fi.intel.com>
	 <1388676172.25123.93.camel@sauron.fi.intel.com>
	 <71CF8D7F32C5C24C9CD1D0E02D52498A770BA889@NTXXIAMBX02.xacn.micron.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.5 (3.8.5-2.fc19) 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-01-03 at 02:31 +0000, Qi Wang 王起 (qiwang) wrote:
> OK, thank you Artem.
> 
> I will change to git send-mail next time. And I will be very careful to push patch to you next time.
> Sorry to bring so much trouble to you as I am first time to push patch to Linux main trunk.(Maybe it also is Micron Technology company first time to push patch to Linux main trunk, I am being Micron China Shanghai team volunteer to contact Linux committee to push patch). 
> Anyway, Thanks for your patience to give me a good starting. 
> And if you have anything need my or my team help, Please kindly let me know. Our team is glad to contribute to Linux community.
> Wish you have a wonderful 2014.

Please, remember that I pushed your patch to a temporary branch, only
for you to be able to easily pick it. I do not send it upstream.

As I said, I need to you look at it and confirm that it is all-right.
And if it is not all-right, correct it.

This is because I modified it myself.

So waiting for your response on this.

-- 
Best Regards,
Artem Bityutskiy

