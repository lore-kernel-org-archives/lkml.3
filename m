Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756093AbaC0Li1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2014 07:38:27 -0400
Received: from smtp4out.l-3com.com ([128.170.207.112]:18499 "EHLO
	smtp4out.l-3com.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751567AbaC0LiZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2014 07:38:25 -0400
X-filenames: 
X-filesizes: None
X-filetypes: 
X-IronPort-AV: E=Sophos;i="4.97,742,1389744000"; 
   d="scan'208";a="218940244"
X-IronPort-AV: E=Sophos;i="4.97,742,1389765600"; 
   d="scan'208";a="5376293"
From: <jimmie.davis@l-3com.com>
To: <hancockrwd@gmail.com>, <umgwanakikbuti@gmail.com>
CC: <oneukum@suse.de>, <artem_fetishev@epam.com>, <peterz@infradead.org>,
        <kosaki.motohiro@jp.fujitsu.com>, <linux-kernel@vger.kernel.org>
Subject: RE: Bug 71331 - mlock yields processor to lower priority process
Thread-Topic: Bug 71331 - mlock yields processor to lower priority process
Thread-Index: AQHPRNwZPC5PRgt+P0GtAN8yDFKRX5rrmJkA///XPHuAAG8YgP//rVNFgABlNQD//6xjLQEmFDsAAACzuGA=
Date: Thu, 27 Mar 2014 11:37:33 +0000
Message-ID: <FFF95760268D324AB6DD9426E83C8DF70B2E730A@ARLEXCHMBX01.lst.link.l-3com.com>
References: <20140321200248.GB6264@owamsq.epam.com>
	 ,<1395393822.6030.59.camel@marge.simpson.net>
	 <FFF95760268D324AB6DD9426E83C8DF70B2E5870@ARLEXCHMBX01.lst.link.l-3com.com>
	 ,<1395408925.9455.3.camel@linux-fkkt.site>
	 <FFF95760268D324AB6DD9426E83C8DF70B2E58FB@ARLEXCHMBX01.lst.link.l-3com.com>,<1395412904.6030.126.camel@marge.simpson.net>
 <FFF95760268D324AB6DD9426E83C8DF70B2E595F@ARLEXCHMBX01.lst.link.l-3com.com>
 <5333BF0C.2030102@gmail.com>
In-Reply-To: <5333BF0C.2030102@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [130.210.49.246]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  

> Generally real-time applications should not be doing mlock calls during 
> their real-time execution for that reason. The required memory regions 
> should be locked during startup so that this kind of execution delay can 
> be avoided at runtime.

Total agreement on this.
 .

Regards,
Bud Davis




  

