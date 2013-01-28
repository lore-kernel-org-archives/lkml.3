Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757495Ab3A1RRc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 12:17:32 -0500
Received: from mga02.intel.com ([134.134.136.20]:53370 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756247Ab3A1RR3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 12:17:29 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,553,1355126400"; 
   d="scan'208";a="253674159"
From: "Allan, Bruce W" <bruce.w.allan@intel.com>
To: David Miller <davem@davemloft.net>,
        "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>
CC: "apw@canonical.com" <apw@canonical.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [PATCH] checkpatch.pl: Fix warnings on code comments
Thread-Topic: [PATCH] checkpatch.pl: Fix warnings on code comments
Thread-Index: AQHN/IKP55ZFPrulJE6JH44Db9+4ZZheYbAAgAAxnYCAAAL/AIAAZpUg
Date: Mon, 28 Jan 2013 17:17:27 +0000
Message-ID: <804857E1F29AAC47BF68C404FC60A1843ABC3058@ORSMSX102.amr.corp.intel.com>
References: <1359286539-18395-1-git-send-email-jeffrey.t.kirsher@intel.com>
	<20130127.185910.1743425400733006443.davem@davemloft.net>
	<1359341805.2255.56.camel@jtkirshe-mobl>
 <20130127.220728.634216960903942581.davem@davemloft.net>
In-Reply-To: <20130127.220728.634216960903942581.davem@davemloft.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.22.254.139]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: netdev-owner@vger.kernel.org [mailto:netdev-
> owner@vger.kernel.org] On Behalf Of David Miller
> Sent: Sunday, January 27, 2013 7:07 PM
> To: Kirsher, Jeffrey T
> Cc: apw@canonical.com; linux-kernel@vger.kernel.org;
> netdev@vger.kernel.org
> Subject: Re: [PATCH] checkpatch.pl: Fix warnings on code comments
> 
> From: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
> Date: Sun, 27 Jan 2013 18:56:45 -0800
> 
> > So will you be fine with cleanup patches which go through and
> > convert all the existing code comments to the desired format?
> 
> Sure.

Not all Intel drivers...e1000e already conforms to the comment style :-)

Bruce.
