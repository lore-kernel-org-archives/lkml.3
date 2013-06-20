Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757952Ab3FTQXX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 12:23:23 -0400
Received: from mga09.intel.com ([134.134.136.24]:43538 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757748Ab3FTQXW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 12:23:22 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,906,1363158000"; 
   d="scan'208";a="356864770"
From: "Heasley, Seth" <seth.heasley@intel.com>
To: Samuel Ortiz <sameo@linux.intel.com>
CC: Peter Tyser <ptyser@xes-inc.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Ralston, James D" <james.d.ralston@intel.com>
Subject: RE: [PATCH 4/4] lpc_ich: iTCO_wdt patch for Intel Coleto Creek
 DeviceIDs
Thread-Topic: [PATCH 4/4] lpc_ich: iTCO_wdt patch for Intel Coleto Creek
 DeviceIDs
Thread-Index: AQHObUnk1krMJwlMpU29tGlBlc7Dx5k+wkEAgAAH25A=
Date: Thu, 20 Jun 2013 16:23:20 +0000
Message-ID: <DEC3922D1904474A8862C7BFF516EA9A8653A1FF@ORSMSX101.amr.corp.intel.com>
References: <1371686665-6622-1-git-send-email-seth.heasley@intel.com>
 <20130620085416.GE15667@zurbaran>
In-Reply-To: <20130620085416.GE15667@zurbaran>
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

Hi Samuel,

>> This patch adds the LPC Controller DeviceIDs for iTCO Watchdog for the Intel
>Coleto Creek PCH.
>>
>> Signed-off-by: Seth Heasley <seth.heasley@intel.com>
>> ---
>>  drivers/mfd/lpc_ich.c |    7 +++++++
>>  1 files changed, 7 insertions(+), 0 deletions(-)
>This one did not apply on top of mfd-next, because of the Avoton SoC
>addition.
>I fixed it manually, but please verify that it's all right:
>
>https://git.kernel.org/cgit/linux/kernel/git/sameo/mfd-
>next.git/commit/?id=283aae8ab88e695a660c610d6535ca44bc5b8835

That looks good.
-Seth
