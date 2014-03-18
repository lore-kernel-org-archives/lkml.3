Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752672AbaCRGGd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 02:06:33 -0400
Received: from mga09.intel.com ([134.134.136.24]:61192 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750923AbaCRGGc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 02:06:32 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,675,1389772800"; 
   d="scan'208";a="474662354"
From: "Winkler, Tomas" <tomas.winkler@intel.com>
To: Greg KH <gregkh@linuxfoundation.org>
CC: "arnd@arndb.de" <arnd@arndb.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Usyskin, Alexander" <alexander.usyskin@intel.com>
Subject: RE: [char-misc-next 3/3 V2] mei: report consistently
 copy_from/to_user failures
Thread-Topic: [char-misc-next 3/3 V2] mei: report consistently
 copy_from/to_user failures
Thread-Index: AQHPQjNm2VIb5uH2OUWa1CqhNlC0uprmWzNg
Date: Tue, 18 Mar 2014 06:06:11 +0000
Message-ID: <5B8DA87D05A7694D9FA63FD143655C1B1AFA1F4B@HASMSX106.ger.corp.intel.com>
References: <1394623153-27046-1-git-send-email-tomas.winkler@intel.com>
 <20140317225310.GA28519@kroah.com>
In-Reply-To: <20140317225310.GA28519@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.184.70.13]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> On Wed, Mar 12, 2014 at 01:19:13PM +0200, Tomas Winkler wrote:
> > From: Alexander Usyskin <alexander.usyskin@intel.com>
> >
> > Consistently display error on possible copy_from/to_user failures
> > use dev_dbg  so it cannot be abused to flood the kernel log
> >
> > Signed-off-by: Alexander Usyskin <alexander.usyskin@intel.com>
> > Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
> > Reviewed-on: https://git-isdc.jer.intel.com/gerrit/1158
> 
> That's a non-public URL, so it doesn't make sense to be put into a
> kernel changelog :(

Yep, sorry for that, something went wrong with my cleanup script, shall I resubmit or can you remove it by hand.

Thanks 
Tomas

