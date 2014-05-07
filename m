Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755570AbaEGIle (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 04:41:34 -0400
Received: from mx0.aculab.com ([213.249.233.131]:42516 "HELO mx0.aculab.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753889AbaEGIlc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 04:41:32 -0400
From: David Laight <David.Laight@ACULAB.COM>
To: "'josh@joshtriplett.org'" <josh@joshtriplett.org>,
        David Miller <davem@davemloft.net>
CC: "andi@firstfloor.org" <andi@firstfloor.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "tom.zanussi@linux.intel.com" <tom.zanussi@linux.intel.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>
Subject: RE: [PATCH 08/24] net, diet: Make TCP metrics optional
Thread-Topic: [PATCH 08/24] net, diet: Make TCP metrics optional
Thread-Index: AQHPaUm7pnbijwvGKES/wM+DbrX4rps0y/dw
Date: Wed, 7 May 2014 08:39:09 +0000
Message-ID: <063D6719AE5E284EB5DD2968C1650D6D0F70DE29@AcuExch.aculab.com>
References: <20140506032114.GP2382@two.firstfloor.org>
 <20140505.232327.578134514220748085.davem@davemloft.net>
 <20140506155703.GA20391@cloud>
 <20140506.115941.428706504757835279.davem@davemloft.net>
 <20140506164108.GA20536@cloud>
In-Reply-To: <20140506164108.GA20536@cloud>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.202.99.200]
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: josh@joshtriplett.org
...
> Every KB of RAM costs real money and SoC die area (for eDRAM/eSRAM).
> Look at how much cache low-end processors have, and imagine running
> entirely out of *that*.  Let's not surrender that entire class of
> devices to VxWorks, FreeRTOS, and other painfully non-Linux systems,
> when we already know it's possible to run Linux on them successfully.

Have you considered running (say) NetBSD instead of Linux?
You'll get more support there for running on 'small memory' systems.
You can also make your own changes with having issues with the GPL.

	David



