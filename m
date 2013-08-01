Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757498Ab3HAXnA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Aug 2013 19:43:00 -0400
Received: from mga09.intel.com ([134.134.136.24]:6223 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753892Ab3HAXm7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Aug 2013 19:42:59 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,797,1367996400"; 
   d="scan'208";a="355805608"
From: "Luck, Tony" <tony.luck@intel.com>
To: Aruna Balakrishnaiah <aruna@linux.vnet.ibm.com>,
        "linuxppc-dev@ozlabs.org" <linuxppc-dev@ozlabs.org>,
        "paulus@samba.org" <paulus@samba.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "benh@kernel.crashing.org" <benh@kernel.crashing.org>,
        "keescook@chromium.org" <keescook@chromium.org>
CC: "jkenisto@linux.vnet.ibm.com" <jkenisto@linux.vnet.ibm.com>,
        "mahesh@linux.vnet.ibm.com" <mahesh@linux.vnet.ibm.com>,
        "cbouatmailru@gmail.com" <cbouatmailru@gmail.com>,
        "anton@samba.org" <anton@samba.org>,
        "ccross@android.com" <ccross@android.com>
Subject: RE: [PATCH 00/11] Add compression support to pstore
Thread-Topic: [PATCH 00/11] Add compression support to pstore
Thread-Index: AQHOgXwu4GtCbRIYRUui47zYtBK3EJmAuVQAgABk2SA=
Date: Thu, 1 Aug 2013 23:42:56 +0000
Message-ID: <3908561D78D1C84285E8C5FCA982C28F31CAA167@ORSMSX106.amr.corp.intel.com>
References: <20130715164844.1520.27771.stgit@aruna-ThinkPad-T420>
 <51FA3B02.7060004@linux.vnet.ibm.com>
In-Reply-To: <51FA3B02.7060004@linux.vnet.ibm.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.22.254.140]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>     Could you please review and let me know your comments!!

Skimmed through it today and didn't notice anything I hated.  It built fine - but doesn't seem to be working on top of ERST.  This doesn't seem to be your fault though, when I rebuilt a plain 3.11-rc3 it didn't log anything via pstore either :-(

Will dig some more at it tomorrow.

-Tony
