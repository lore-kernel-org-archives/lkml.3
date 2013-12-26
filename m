Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753571Ab3LZRwW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Dec 2013 12:52:22 -0500
Received: from mail-pb0-f41.google.com ([209.85.160.41]:49703 "EHLO
	mail-pb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753395Ab3LZRwV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Dec 2013 12:52:21 -0500
Date: Thu, 26 Dec 2013 09:52:13 -0800
From: Brian Norris <computersforpeace@gmail.com>
To: Qi Wang =?utf-8?B?546L6LW3IChxaXdhbmcp?= <qiwang@micron.com>
Cc: "dedekind1@gmail.com" <dedekind1@gmail.com>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/1]  MTD: UBI:  try to avoid program data to NOR flash
 after erasure interrupted
Message-ID: <20131226175213.GA15560@norris-Latitude-E6410>
References: <71CF8D7F32C5C24C9CD1D0E02D52498A77082DDB@NTXXIAMBX02.xacn.micron.com>
 <71CF8D7F32C5C24C9CD1D0E02D52498A770AED11@NTXXIAMBX02.xacn.micron.com>
 <71CF8D7F32C5C24C9CD1D0E02D52498A770AED44@NTXXIAMBX02.xacn.micron.com>
 <71CF8D7F32C5C24C9CD1D0E02D52498A770AED67@NTXXIAMBX02.xacn.micron.com>
 <1382779164.5901.1.camel@karhu.quadriga.com>
 <71CF8D7F32C5C24C9CD1D0E02D52498A770B1B97@NTXXIAMBX02.xacn.micron.com>
 <1383059901.29619.52.camel@sauron.fi.intel.com>
 <71CF8D7F32C5C24C9CD1D0E02D52498A770B220C@NTXXIAMBX02.xacn.micron.com>
 <1383296284.2722.73.camel@sauron.fi.intel.com>
 <71CF8D7F32C5C24C9CD1D0E02D52498A770B943C@NTXXIAMBX02.xacn.micron.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <71CF8D7F32C5C24C9CD1D0E02D52498A770B943C@NTXXIAMBX02.xacn.micron.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 23, 2013 at 02:03:16AM +0000, Qi Wang 王起 (qiwang) wrote:
> Sorry to interrupt your busy life. 

Yes, unfortunately Artem hasn't been too responsive lately.

> As you said in previous mail, I send my patch separately without
> quoting this e-mail. And I have send to you, but I never get  your
> reply. I am very confuse, no sure if is there anything wrong at the
> patch I send to you.
> Can you help explain to me?

I'm not really a UBI expert, but I doubt that there is a real problem
with your patch. Artem just hasn't had time to look at it again.

Although you have been waiting a while, I suppose the best option is
simply to wait some more. Artem tends to revisit patches eventually,
sometimes after several weeks/months.

Brian
