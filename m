Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965190Ab3IDQkw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Sep 2013 12:40:52 -0400
Received: from usindpps04.hds.com ([207.126.252.17]:54090 "EHLO
	usindpps04.hds.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935245Ab3IDQku convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Sep 2013 12:40:50 -0400
From: Seiji Aguchi <seiji.aguchi@hds.com>
To: "Luck, Tony" <tony.luck@intel.com>,
        Aruna Balakrishnaiah <aruna@linux.vnet.ibm.com>
CC: "jkenisto@linux.vnet.ibm.com" <jkenisto@linux.vnet.ibm.com>,
        "keescook@chromium.org" <keescook@chromium.org>,
        "mahesh@linux.vnet.ibm.com" <mahesh@linux.vnet.ibm.com>,
        "ccross@android.com" <ccross@android.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linuxppc-dev@ozlabs.org" <linuxppc-dev@ozlabs.org>,
        "cbouatmailru@gmail.com" <cbouatmailru@gmail.com>
Subject: RE: [RFC PATCH v2 04/11] pstore: Add compression support to pstore
Thread-Topic: [RFC PATCH v2 04/11] pstore: Add compression support to pstore
Thread-Index: AQHOmoMcsKHK3fNXLUCcb5sKdMjJG5mhyInAgABg8gCABq6lAIAMBsAQgACXa4CAAKp9gP//xBmw
Date: Wed, 4 Sep 2013 16:39:23 +0000
Message-ID: <A5ED84D3BB3A384992CBB9C77DEDA4D443E9F05D@USINDEM103.corp.hds.com>
References: <20130816131403.3338.82330.stgit@aruna-ThinkPad-T420>
 <20130816131805.3338.68767.stgit@aruna-ThinkPad-T420>
 <A5ED84D3BB3A384992CBB9C77DEDA4D443E8F0D7@USINDEM103.corp.hds.com>
 <3908561D78D1C84285E8C5FCA982C28F31CC7AC0@ORSMSX106.amr.corp.intel.com>
 <521C36F4.8030607@linux.vnet.ibm.com>
 <A5ED84D3BB3A384992CBB9C77DEDA4D443E9E24D@USINDEM103.corp.hds.com>
 <5226CC9D.30904@linux.vnet.ibm.com>
 <3908561D78D1C84285E8C5FCA982C28F31CDB23E@ORSMSX106.amr.corp.intel.com>
In-Reply-To: <3908561D78D1C84285E8C5FCA982C28F31CDB23E@ORSMSX106.amr.corp.intel.com>
Accept-Language: ja-JP, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.74.73.11]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 mx ip4:207.126.244.0/26 ip4:207.126.252.0/25 include:mktomail.com
 include:cloud.hds.com ~all
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.10.8794,1.0.431,0.0.0000
 definitions=2013-09-04_06:2013-09-04,2013-09-04,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=outbound_policy score=0 spamscore=0 suspectscore=0
 phishscore=0 adultscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=7.0.1-1305240000 definitions=main-1309040046
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> But let's make sure that efivars, erst,
> etc. are all happy with the changes we make before I ask Linus to pull another
> pstore piece.

I will test efivars when Aruna posts the bugfix patches.

Seiji

> -----Original Message-----
> From: Luck, Tony [mailto:tony.luck@intel.com]
> Sent: Wednesday, September 04, 2013 12:11 PM
> To: Aruna Balakrishnaiah; Seiji Aguchi
> Cc: jkenisto@linux.vnet.ibm.com; keescook@chromium.org; mahesh@linux.vnet.ibm.com; ccross@android.com; linux-
> kernel@vger.kernel.org; linuxppc-dev@ozlabs.org; cbouatmailru@gmail.com
> Subject: RE: [RFC PATCH v2 04/11] pstore: Add compression support to pstore
> 
> > The reason behind compression failure is the size of big_oops_buf which is too
> > big for efivars case. I will do some experiments with different kind of texts
> > for buffer size 1024 to check if 100/53 suits for all the cases.
> ...
> 
> > Yes this can be changed to zlib_inflateInit2().
> 
> Original patch series was just pulled by Linus ... so we'll need a patch on top
> of current Linus git tree to fix these issues.  But let's make sure that efivars, erst,
> etc. are all happy with the changes we make before I ask Linus to pull another
> pstore piece.
> 
> Thanks
> 
> -Tony
