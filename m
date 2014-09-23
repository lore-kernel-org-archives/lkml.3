Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932372AbaIWVJr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 17:09:47 -0400
Received: from 99-65-72-228.uvs.sntcca.sbcglobal.net ([99.65.72.228]:27649
	"EHLO stargate.chelsio.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932298AbaIWVJk convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 17:09:40 -0400
From: Anish Bhatt <anish@chelsio.com>
To: Guenter Roeck <linux@roeck-us.net>,
        Andrew Morton <akpm@linux-foundation.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        "sfr@canb.auug.org.au" <sfr@canb.auug.org.au>,
        "mhocko@suse.cz" <mhocko@suse.cz>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Sasha Levin <sasha.levin@oracle.com>,
        "David Miller" <davem@davemloft.net>,
        Fabio Estevam <fabio.estevam@freescale.com>,
        Randy Dunlap <rdunlap@infradead.org>
Subject: RE: mmotm 2014-09-22-16-57 uploaded
Thread-Topic: mmotm 2014-09-22-16-57 uploaded
Thread-Index: AQHP12ksP0HrfSnps0K2Vm1mxVnDCZwPozQA//+R+7A=
Date: Tue, 23 Sep 2014 21:08:54 +0000
Message-ID: <525DB349B3FB5444AE057A887CB2A8D88F1F9D@nice.asicdesigners.com>
References: <5420b8b0.9HdYLyyuTikszzH8%akpm@linux-foundation.org>
 <20140923190222.GA4662@roeck-us.net>
 <20140923130128.79f5931ac03dbb31f53be805@linux-foundation.org>
 <20140923203832.GA1112@roeck-us.net>
In-Reply-To: <20140923203832.GA1112@roeck-us.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.192.161.23]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > cc'ing Anish Bhatt.
> >
> He knows about it, as do David Miller and Randy Dunlap (who proposed it)
> [1].
> There just doesn't seem to be an agreement on how to fix the problem.
> A simple revert doesn't work anymore since there are multiple follow-up
> patches, and if I understand correctly David is opposed to a revert anyway.

Dave is working on  a patch based on Randy's last solution :
http://www.spinics.net/lists/netdev/msg297593.html

Not sure of the current status.
-Anish
