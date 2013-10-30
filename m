Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753692Ab3J3HQO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Oct 2013 03:16:14 -0400
Received: from mga03.intel.com ([143.182.124.21]:28500 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751647Ab3J3HQM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Oct 2013 03:16:12 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,535,1378882800"; 
   d="scan'208";a="382098397"
From: "Winkler, Tomas" <tomas.winkler@intel.com>
To: Greg KH <gregkh@linuxfoundation.org>
CC: "arnd@arndb.de" <arnd@arndb.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [char-misc-next 1/8] mei: debugfs: validate dev is not null
Thread-Topic: [char-misc-next 1/8] mei: debugfs: validate dev is not null
Thread-Index: AQHO1P06TyNlQAzZmEa3ng99D0wzFJoM1X5g
Date: Wed, 30 Oct 2013 07:16:07 +0000
Message-ID: <5B8DA87D05A7694D9FA63FD143655C1B1AEFB8F5@HASMSX106.ger.corp.intel.com>
References: <1382382343-12066-1-git-send-email-tomas.winkler@intel.com>
 <1382382343-12066-2-git-send-email-tomas.winkler@intel.com>
 <20131029231841.GA30410@kroah.com>
In-Reply-To: <20131029231841.GA30410@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.184.70.12]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> On Mon, Oct 21, 2013 at 10:05:36PM +0300, Tomas Winkler wrote:
> > make static analyzer happy
> 
> That's a stupid analyzer.
> 
> Sorry, this case can never be true, so don't check for it.  Fix your
> analyzer.
> 
> > and validate dev argument before dereferencing
> 
> Again, no need to do so, it's always set properly.
> 
> sorry, I can't take this.

Fair enough, I didn't like that patch myself now I have other confirmation that this is stupid.
 
Tomas

