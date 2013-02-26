Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759977Ab3BZCIm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2013 21:08:42 -0500
Received: from mga03.intel.com ([143.182.124.21]:55921 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751366Ab3BZCIj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2013 21:08:39 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,736,1355126400"; 
   d="scan'208";a="261365358"
From: "Heasley, Seth" <seth.heasley@intel.com>
To: Neil Horman <nhorman@tuxdriver.com>
CC: Wolfram Sang <wsa@the-dreams.de>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Ralston, James D" <james.d.ralston@intel.com>
Subject: RE: [PATCH 1/1] i2c: iSMT SMBus patch for Intel Avoton DeviceIDs
Thread-Topic: [PATCH 1/1] i2c: iSMT SMBus patch for Intel Avoton DeviceIDs
Thread-Index: AQHOEHsi+AZRAVxuOE6I7EZlYEh9dZiFXF8A//+FJuCAAJlQgIAF8Cew
Date: Tue, 26 Feb 2013 02:08:35 +0000
Message-ID: <DEC3922D1904474A8862C7BFF516EA9A7115EA33@ORSMSX101.amr.corp.intel.com>
References: <1361485843-13560-1-git-send-email-seth.heasley@intel.com>
 <20130221213714.GB32764@hmsreliant.think-freely.org>
 <DEC3922D1904474A8862C7BFF516EA9A7115E094@ORSMSX101.amr.corp.intel.com>
 <20130221232615.GA3046@neilslaptop.think-freely.org>
In-Reply-To: <20130221232615.GA3046@neilslaptop.think-freely.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.22.254.138]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> The difference here is that the S1200 name is already publicly released,
>whereas the naming for Avoton hasn't been announced.
>>
>Do you know when the announcement will be?  Is it sufficiently soon that we
>can just wait for it?

I don't, and actually couldn't tell you if I did.  The codename usage is consistent with how we deal with all products since the patches have to go in well in advance of product launch.

-Seth
