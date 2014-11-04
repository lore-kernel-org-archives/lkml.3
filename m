Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752268AbaKDSQe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 13:16:34 -0500
Received: from mga02.intel.com ([134.134.136.20]:25195 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751751AbaKDSQc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 13:16:32 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,314,1413270000"; 
   d="scan'208";a="631320598"
From: "Winkler, Tomas" <tomas.winkler@intel.com>
To: Greg KH <gregkh@linuxfoundation.org>
CC: "arnd@arndb.de" <arnd@arndb.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Usyskin, Alexander" <alexander.usyskin@intel.com>
Subject: RE: [char-misc V3 3.18] mei: nfc: clean nfc internal struct on host
 exit
Thread-Topic: [char-misc V3 3.18] mei: nfc: clean nfc internal struct on
 host exit
Thread-Index: AQHP+E0ayfgvAb56aEuyBAb6C8vN4pxQxcCQ
Date: Tue, 4 Nov 2014 18:16:09 +0000
Message-ID: <5B8DA87D05A7694D9FA63FD143655C1B1C494C67@HASMSX106.ger.corp.intel.com>
References: <1415110489-25270-1-git-send-email-tomas.winkler@intel.com>
 <20141104163148.GB14034@kroah.com>
In-Reply-To: <20141104163148.GB14034@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.184.70.11]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Greg KH [mailto:gregkh@linuxfoundation.org]
> Sent: Tuesday, November 04, 2014 18:32
> To: Winkler, Tomas
> Cc: arnd@arndb.de; linux-kernel@vger.kernel.org; Usyskin, Alexander
> Subject: Re: [char-misc V3 3.18] mei: nfc: clean nfc internal struct on host exit
> 
> On Tue, Nov 04, 2014 at 04:14:49PM +0200, Tomas Winkler wrote:
> > NFC internal structure cleaning was dropped by commit
> >
> > commit 5ad1550a15cd5b75ed8aa3009e162822f720375e
> > Author: Tomas Winkler <tomas.winkler@intel.com>
> > Date:   Sun Jan 26 11:53:06 2014 +0200
> 
> Where is this commit id from?  I don't see it in Linus's tree.

This is the correct one 487056932d372cc4f6c636f21a928d6667b151d7
Will resend.
Tomas

