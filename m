Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753878Ab3HPWP1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Aug 2013 18:15:27 -0400
Received: from mga02.intel.com ([134.134.136.20]:46692 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753692Ab3HPWPX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Aug 2013 18:15:23 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,898,1367996400"; 
   d="scan'208";a="363904831"
From: "Luck, Tony" <tony.luck@intel.com>
To: Aruna Balakrishnaiah <aruna@linux.vnet.ibm.com>,
        "linuxppc-dev@ozlabs.org" <linuxppc-dev@ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "keescook@chromium.org" <keescook@chromium.org>
CC: "jkenisto@linux.vnet.ibm.com" <jkenisto@linux.vnet.ibm.com>,
        "ananth@in.ibm.com" <ananth@in.ibm.com>,
        "benh@kernel.crashing.org" <benh@kernel.crashing.org>,
        "cbouatmailru@gmail.com" <cbouatmailru@gmail.com>,
        "mahesh@linux.vnet.ibm.com" <mahesh@linux.vnet.ibm.com>,
        "ccross@android.com" <ccross@android.com>
Subject: RE: [RFC PATCH v2 00/11] Add (de)compression support to pstore
Thread-Topic: [RFC PATCH v2 00/11] Add (de)compression support to pstore
Thread-Index: AQHOmoL9OP5jkTc76EGOPV29h5KfTJmYZmQw
Date: Fri, 16 Aug 2013 22:15:21 +0000
Message-ID: <3908561D78D1C84285E8C5FCA982C28F31CBF152@ORSMSX106.amr.corp.intel.com>
References: <20130816131403.3338.82330.stgit@aruna-ThinkPad-T420>
In-Reply-To: <20130816131403.3338.82330.stgit@aruna-ThinkPad-T420>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.22.254.140]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r7GMFZuT025339

> Needs testing with erst backend, efivars and persistent ram.

Tested against ERST - works fine for me now.

Need to stare at the code to see if there are any more bits that could be cleaned up.

Thanks for addressing my issues from v1

-Tony
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
