Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751790Ab3HTPdZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 11:33:25 -0400
Received: from mga14.intel.com ([143.182.124.37]:45228 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751250Ab3HTPdX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 11:33:23 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,921,1367996400"; 
   d="scan'208";a="349049780"
From: "Berg, Johannes" <johannes.berg@intel.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Shuah Khan <shuah.kh@samsung.com>, Stefan Lippers-Hollmann <s.L-H@gmx.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "shuahkhan@gmail.com" <shuahkhan@gmail.com>,
        "'johannes@sipsolutions.net'" <johannes@sipsolutions.net>
Subject: RE: [ 00/34] 3.4.59-stable review
Thread-Topic: [ 00/34] 3.4.59-stable review
Thread-Index: AQHOnSvKoRb0OTzpkki8rSvjSssr4pmdtSuQgAByUYCAABLnkA==
Date: Tue, 20 Aug 2013 15:32:43 +0000
Message-ID: <1DC40B07CD6EC041A66726C271A73AE61AA6FAC2@IRSMSX102.ger.corp.intel.com>
References: <20130818203259.653403173@linuxfoundation.org>
 <52125DA9.3090601@samsung.com> <20130819193538.GB24897@kroah.com>
 <201308192214.54917.s.L-H@gmx.de> <52129AC3.5020402@samsung.com>
 <20130819223037.GA3838@kroah.com>
 <1DC40B07CD6EC041A66726C271A73AE61AA6B9CC@IRSMSX102.ger.corp.intel.com>
 <20130820152401.GA5211@kroah.com>
In-Reply-To: <20130820152401.GA5211@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [163.33.239.182]
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > Yeah, I'm trying to get that, but it's not clear to me how to fix it.
> > Where did you apply it? It was going to need some fixes but when the
> > first objection was raised I figured you were going to drop it for now
> > completely? Sorry for the mess :-(
> 
> You're right, I'll drop this for 3.4, it doesn't make sense there.

Technically, the bug does exist on 3.4 (it was actually reported to me there :) ) but the fix would have to be significantly different, there's very different locking for dump in generic netlink there. Given that I can't even seem to figure out the current version, it's probably best to not worry about 3.4 ...

johannes
-- 

Intel GmbH
Dornacher Strasse 1
85622 Feldkirchen/Muenchen, Deutschland
Sitz der Gesellschaft: Feldkirchen bei Muenchen
Geschaeftsfuehrer: Christian Lamprechter, Hannes Schwaderer, Douglas Lusk
Registergericht: Muenchen HRB 47456
Ust.-IdNr./VAT Registration No.: DE129385895
Citibank Frankfurt a.M. (BLZ 502 109 00) 600119052

