Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932883AbaDCCFf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2014 22:05:35 -0400
Received: from TYO202.gate.nec.co.jp ([210.143.35.52]:51068 "EHLO
	tyo202.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932423AbaDCCFd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2014 22:05:33 -0400
From: Madoka Komatsubara <m-komatsubara@ab.jp.nec.com>
To: David Miller <davem@davemloft.net>,
        "todd.fujinaka@intel.com" <todd.fujinaka@intel.com>,
        "donald.c.skidmore@intel.com" <donald.c.skidmore@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "e1000-devel@lists.sourceforge.net" 
	<e1000-devel@lists.sourceforge.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>,
        Hiroshi Baba <h-baba@ax.jp.nec.com>
Subject: RE: [E1000-devel] fail to add 64 VLANs or more when SR-IOV is
 enabled
Thread-Topic: [E1000-devel] fail to add 64 VLANs or more when SR-IOV is
 enabled
Thread-Index: AQHPTt1gvAUZA3aa9kCshbi+iImnxJr/Io0g
Date: Thu, 3 Apr 2014 02:03:43 +0000
Message-ID: <9DE5760509B7974286F38D93BF31DD62C7E200@BPXM13GP.gisp.nec.co.jp>
References: <9DE5760509B7974286F38D93BF31DD62C7DF93@BPXM13GP.gisp.nec.co.jp>
	<9B4A1B1917080E46B64F07F2989DADD652978166@ORSMSX102.amr.corp.intel.com>
	<9DE5760509B7974286F38D93BF31DD62C7E125@BPXM13GP.gisp.nec.co.jp>
 <20140402.213941.1530194697006154708.davem@davemloft.net>
In-Reply-To: <20140402.213941.1530194697006154708.davem@davemloft.net>
Accept-Language: ja-JP, en-US
Content-Language: ja-JP
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.205.8.69]
Content-Type: text/plain; charset="iso-2022-jp"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> -----Original Message-----
> From: David Miller [mailto:davem@davemloft.net]
> Sent: Thursday, April 03, 2014 10:40 AM
> To: Komatsubara Madoka(小松原 円)
> Cc: todd.fujinaka@intel.com; donald.c.skidmore@intel.com;
> linux-kernel@vger.kernel.org; e1000-devel@lists.sourceforge.net;
> netdev@vger.kernel.org; Shimamoto Hiroshi(島本 裕志); Baba Hiroshi(馬場 裕
> 司)
> Subject: Re: [E1000-devel] fail to add 64 VLANs or more when SR-IOV is enabled
> 
> From: Madoka Komatsubara <m-komatsubara@ab.jp.nec.com>
> Date: Thu, 3 Apr 2014 01:12:13 +0000
> 
> > Thank you for the quick response.
> > How can I increase the limit？
> 
> It's a hardware limit, you cannot increase it.


Thank you for your information.
Does it mean disabling filter is the only way to use over 64 VLANs and is it possible?

Regards,
Madoka

