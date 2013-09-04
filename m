Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763037Ab3IDQLW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Sep 2013 12:11:22 -0400
Received: from mga14.intel.com ([143.182.124.37]:38830 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756436Ab3IDQLT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Sep 2013 12:11:19 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,1022,1367996400"; 
   d="scan'208";a="290776725"
From: "Luck, Tony" <tony.luck@intel.com>
To: Aruna Balakrishnaiah <aruna@linux.vnet.ibm.com>,
        Seiji Aguchi <seiji.aguchi@hds.com>
CC: "jkenisto@linux.vnet.ibm.com" <jkenisto@linux.vnet.ibm.com>,
        "keescook@chromium.org" <keescook@chromium.org>,
        "mahesh@linux.vnet.ibm.com" <mahesh@linux.vnet.ibm.com>,
        "ccross@android.com" <ccross@android.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linuxppc-dev@ozlabs.org" <linuxppc-dev@ozlabs.org>,
        "cbouatmailru@gmail.com" <cbouatmailru@gmail.com>
Subject: RE: [RFC PATCH v2 04/11] pstore: Add compression support to pstore
Thread-Topic: [RFC PATCH v2 04/11] pstore: Add compression support to pstore
Thread-Index: AQHOmoMbiAeVAEJI6Eexn1HhYtGcd5miWTOA//+LrwCAByWJAIAMVp+AgABHjICAADRIEA==
Date: Wed, 4 Sep 2013 16:11:13 +0000
Message-ID: <3908561D78D1C84285E8C5FCA982C28F31CDB23E@ORSMSX106.amr.corp.intel.com>
References: <20130816131403.3338.82330.stgit@aruna-ThinkPad-T420>
 <20130816131805.3338.68767.stgit@aruna-ThinkPad-T420>
 <A5ED84D3BB3A384992CBB9C77DEDA4D443E8F0D7@USINDEM103.corp.hds.com>
 <3908561D78D1C84285E8C5FCA982C28F31CC7AC0@ORSMSX106.amr.corp.intel.com>
 <521C36F4.8030607@linux.vnet.ibm.com>
 <A5ED84D3BB3A384992CBB9C77DEDA4D443E9E24D@USINDEM103.corp.hds.com>
 <5226CC9D.30904@linux.vnet.ibm.com>
In-Reply-To: <5226CC9D.30904@linux.vnet.ibm.com>
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

> The reason behind compression failure is the size of big_oops_buf which is too
> big for efivars case. I will do some experiments with different kind of texts
> for buffer size 1024 to check if 100/53 suits for all the cases.
...

> Yes this can be changed to zlib_inflateInit2().

Original patch series was just pulled by Linus ... so we'll need a patch on top
of current Linus git tree to fix these issues.  But let's make sure that efivars, erst,
etc. are all happy with the changes we make before I ask Linus to pull another
pstore piece.

Thanks

-Tony
