Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161583Ab3DEMkW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Apr 2013 08:40:22 -0400
Received: from mga03.intel.com ([143.182.124.21]:20382 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161378Ab3DEMkV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Apr 2013 08:40:21 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,414,1363158000"; 
   d="scan'208";a="281260897"
From: "Winkler, Tomas" <tomas.winkler@intel.com>
To: Arnd Bergmann <arnd@arndb.de>
CC: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [char-misc-next] mei: add debugfs hooks
Thread-Topic: [char-misc-next] mei: add debugfs hooks
Thread-Index: AQHOMfdB6O1yqceSR0y573uOStrKHJjHkFxA
Date: Fri, 5 Apr 2013 12:40:08 +0000
Message-ID: <5B8DA87D05A7694D9FA63FD143655C1B01EF81F1@HASMSX106.ger.corp.intel.com>
References: <1365119491-10467-1-git-send-email-tomas.winkler@intel.com>
 <201304051415.03122.arnd@arndb.de>
In-Reply-To: <201304051415.03122.arnd@arndb.de>
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


> On Friday 05 April 2013, Tomas Winkler wrote:
> > debugfs exposes device state and list of me clients and their
> > properties
> >
> > Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
> 
> Just one small comment:
> 
> > +#define DEBUGFS_ADD_FILE(_mei, name, parent, mode)	\
> > +	debugfs_create_file(#name, mode, parent,	\
> > +			_mei, &mei_dbgfs_fops_##name)
> 
> 
> This macro seems to obfuscate more than it helps. In general, string
> concatenation in macros is problematic because it means you can no longer
> grep for where a symbols is being used.
> 
This is very common shortcut  mostly used in wireless drivers,
vut I don't mind to open code this, I will resubmit version two,  this patch also needs a fix in the Makefile

Thanks
Tomas

