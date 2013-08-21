Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752060Ab3HUCJ6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 22:09:58 -0400
Received: from mga02.intel.com ([134.134.136.20]:8951 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751408Ab3HUCJ5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 22:09:57 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,924,1367996400"; 
   d="scan'208";a="365903158"
From: "Ma, Xindong" <xindong.ma@intel.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
CC: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "ccross@android.com" <ccross@android.com>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] LMK: Optimize lowmem_shrink
Thread-Topic: [PATCH] LMK: Optimize lowmem_shrink
Thread-Index: AQHOnX/IOu4x6dbkAES6VAPPp0jfAZme6yxQ
Date: Wed, 21 Aug 2013 02:09:42 +0000
Message-ID: <3917C05D9F83184EAA45CE249FF1B1DD024E1EE3@SHSMSX103.ccr.corp.intel.com>
References: <1376961393.20932.8.camel@leonma-sh>
 <20130820083024.GJ22811@mwanda>
In-Reply-To: <20130820083024.GJ22811@mwanda>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> -----Original Message-----
> From: Dan Carpenter [mailto:dan.carpenter@oracle.com]
> Sent: Tuesday, August 20, 2013 4:30 PM
> To: Ma, Xindong
> Cc: gregkh@linuxfoundation.org; ccross@android.com;
> devel@driverdev.osuosl.org; linux-kernel@vger.kernel.org
> Subject: Re: [PATCH] LMK: Optimize lowmem_shrink
> 
> On Tue, Aug 20, 2013 at 09:16:33AM +0800, Leon Ma wrote:
> > From: Leon Ma <xindong.ma@intel.com>
> > Date: Mon, 19 Aug 2013 14:22:38 +0800
> > Subject: [PATCH] LMK: Optimize lowmem_shrink.
> >
> > By comparing with selected_oom_score_adj instead of min_score_adj, we
> > may do less calculation.
> >
> 
> The patch is line wrapped and doesn't apply.
> Read Documentation/email-clients.txt.  Send it to yourself first.
> Save the whole email as raw text (including headers and everything).
> cat email.txt | git am.
> When that works, then resend.
Sorry for the trouble. I forgot to click "Prefomatted" in Evolution. I've resend the patch
https://lkml.org/lkml/2013/8/20/754
Please have a review.
> 
> regards,
> dan carpenter

