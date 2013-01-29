Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756966Ab3A2Nvk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2013 08:51:40 -0500
Received: from mga09.intel.com ([134.134.136.24]:19606 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756924Ab3A2Nvi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2013 08:51:38 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,559,1355126400"; 
   d="scan'208";a="254193541"
From: "Lan, Tianyu" <tianyu.lan@intel.com>
To: Greg KH <gregkh@linuxfoundation.org>
CC: Stephen Rothwell <sfr@canb.auug.org.au>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: linux-next: build failure after merge of the usb tree
Thread-Topic: linux-next: build failure after merge of the usb tree
Thread-Index: AQHN/UTaasownys6vUyJQSycl5ICdJheS3wAgACbnMCAAOT8gIAAiJZA
Date: Tue, 29 Jan 2013 13:51:34 +0000
Message-ID: <4CFBC02C07DA244CA19D6815A05BE6EE1BBF46@SHSMSX101.ccr.corp.intel.com>
References: <20130128214644.a3906eecaf9123b05216dcaf@canb.auug.org.au>
 <20130128144508.GA2997@kroah.com>
 <4CFBC02C07DA244CA19D6815A05BE6EE1BB7F5@SHSMSX101.ccr.corp.intel.com>
 <20130129134139.GD1505@kroah.com>
In-Reply-To: <20130129134139.GD1505@kroah.com>
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

Hi greg:
	My pleasure. I have sent the patch to you and usb mailist yesterday.
http://marc.info/?l=linux-usb&m=135939249906217&w=2
	So please have a check. 

Best Regards 
Tianyu Lan 


-----Original Message-----
From: Greg KH [mailto:gregkh@linuxfoundation.org] 
Sent: Tuesday, January 29, 2013 9:42 PM
To: Lan, Tianyu
Cc: Stephen Rothwell; linux-next@vger.kernel.org; linux-kernel@vger.kernel.org
Subject: Re: linux-next: build failure after merge of the usb tree

On Mon, Jan 28, 2013 at 04:03:07PM +0000, Lan, Tianyu wrote:
> I just check the commit 88bb965ed711 can not git revert smoothly. I 
> will do it and send a revert patch.

Please do so, thanks.

greg k-h
