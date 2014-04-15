Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752451AbaDOCz0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 22:55:26 -0400
Received: from mga09.intel.com ([134.134.136.24]:48665 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750998AbaDOCzY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 22:55:24 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,861,1389772800"; 
   d="scan'208";a="492977848"
From: "Liu, Chuansheng" <chuansheng.liu@intel.com>
To: "Chen, Tingjie" <tingjie.chen@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Jiri Slaby <jslaby@suse.cz>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Zhang, Jun" <jun.zhang@intel.com>,
        "One Thousand Gnomes" <gnomes@lxorguk.ukuu.org.uk>
Subject: RE: [PATCH] [PATCH V2] tty: memleak in alloc_pid
Thread-Topic: [PATCH] [PATCH V2] tty: memleak in alloc_pid
Thread-Index: AQHPV7JyCUamM6iyGUeFZWzTAGRct5sQeQEAgAFsfSCAABa7cA==
Date: Tue, 15 Apr 2014 02:54:21 +0000
Message-ID: <27240C0AC20F114CBF8149A2696CBE4A01CF1F24@SHSMSX101.ccr.corp.intel.com>
References: <1397460675-17983-1-git-send-email-tingjie.chen@intel.com>
 <20140414114704.GB19027@kroah.com>
 <BA0C77F83D4255479F53DBBC4C4BAFC55FF699@SHSMSX101.ccr.corp.intel.com>
In-Reply-To: <BA0C77F83D4255479F53DBBC4C4BAFC55FF699@SHSMSX101.ccr.corp.intel.com>
Accept-Language: zh-CN, en-US
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

> > Change-Id: Ic960dda039c8f99aad3e0f4d176489a966c62f6a
> 
> Why is this line here?

Tingjie, Greg is asking you the sentence of "Change-Id", which is not
needed, please remove it with one new patch.


