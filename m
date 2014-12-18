Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751794AbaLRJhS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Dec 2014 04:37:18 -0500
Received: from mga11.intel.com ([192.55.52.93]:7057 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750959AbaLRJhP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2014 04:37:15 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,599,1413270000"; 
   d="scan'208";a="639562623"
From: "Winkler, Tomas" <tomas.winkler@intel.com>
To: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
CC: "arnd@arndb.de" <arnd@arndb.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [char-misc-next 1/3 V2] mei: add ABI documentation for
 fw_status exported through sysfs
Thread-Topic: [char-misc-next 1/3 V2] mei: add ABI documentation for
 fw_status exported through sysfs
Thread-Index: AQHQCjsERLi9osFcq0OziaUBHOD0bpyVNePQ
Date: Thu, 18 Dec 2014 09:37:12 +0000
Message-ID: <5B8DA87D05A7694D9FA63FD143655C1B2CCED19D@HASMSX106.ger.corp.intel.com>
References: <1417090049-23219-1-git-send-email-tomas.winkler@intel.com>
In-Reply-To: <1417090049-23219-1-git-send-email-tomas.winkler@intel.com>
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



> 
> Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
> ---
> V2: rephrase the description
>  Documentation/ABI/testing/sysfs-class-mei | 15 +++++++++++++++
>  1 file changed, 15 insertions(+)
>
Greg you've  included 'mei: export fw status registers through sysfs' to 3.19-rc1 pull request 
but left this documentation patch out.
 
Thanks
Tomas


