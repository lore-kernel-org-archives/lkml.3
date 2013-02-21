Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758998Ab3BUWTy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2013 17:19:54 -0500
Received: from mga09.intel.com ([134.134.136.24]:9570 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754245Ab3BUWTw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2013 17:19:52 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,711,1355126400"; 
   d="scan'208";a="289002697"
From: "Heasley, Seth" <seth.heasley@intel.com>
To: Neil Horman <nhorman@tuxdriver.com>
CC: Wolfram Sang <wsa@the-dreams.de>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Ralston, James D" <james.d.ralston@intel.com>
Subject: RE: [PATCH 1/1] i2c: iSMT SMBus patch for Intel Avoton DeviceIDs
Thread-Topic: [PATCH 1/1] i2c: iSMT SMBus patch for Intel Avoton DeviceIDs
Thread-Index: AQHOEHsi+AZRAVxuOE6I7EZlYEh9dZiFXF8A//+FJuA=
Date: Thu, 21 Feb 2013 22:19:48 +0000
Message-ID: <DEC3922D1904474A8862C7BFF516EA9A7115E094@ORSMSX101.amr.corp.intel.com>
References: <1361485843-13560-1-git-send-email-seth.heasley@intel.com>
 <20130221213714.GB32764@hmsreliant.think-freely.org>
In-Reply-To: <20130221213714.GB32764@hmsreliant.think-freely.org>
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

Hi Neil,

>> This patch adds the iSMT SMBus Controller DeviceIDs for the Intel Avoton
>SOC.
>>
>> Signed-off-by: Seth Heasley <seth.heasley@intel.com>
>Is there a part number (I.e. S1200) that we can use in the name, rather than
>the project code name?  That would seem to be more in keeping with the
>previous naming scheeme directly above it Neil

The difference here is that the S1200 name is already publicly released, whereas the naming for Avoton hasn't been announced.  

Regards,
-Seth
