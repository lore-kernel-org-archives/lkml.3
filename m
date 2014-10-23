Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755603AbaJWNCo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2014 09:02:44 -0400
Received: from mga14.intel.com ([192.55.52.115]:36345 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755443AbaJWNCl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2014 09:02:41 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="404802200"
From: "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>
To: Pavel Machek <pavel@ucw.cz>, kernel list <linux-kernel@vger.kernel.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "Berg, Johannes" <johannes.berg@intel.com>,
        "ilw@linux.intel.com" <ilw@linux.intel.com>
Subject: RE: 3.18-rc0: iwlegacy failed after a while
Thread-Topic: 3.18-rc0: iwlegacy failed after a while
Thread-Index: Ac/uwXl795E3/2oRTnmJTjtK4+8qsQ==
Date: Thu, 23 Oct 2014 13:02:37 +0000
Message-ID: <0BA3FCBA62E2DC44AF3030971E174FB31B552E3F@hasmsx107.ger.corp.intel.com>
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

[Changed subject]
This is really iwlegacy and not iwlwifi.


> 
> Hi!
> 
> Full dmesg is in the attachment, I guess the troubles started with:
> 
> iwl3945 0000:03:00.0: Queue 4 stuck for 2004 ms.
> iwl3945 0000:03:00.0: On demand firmware reload
> iwl3945 0000:03:00.0: Master Disable Timed Out, 100 usec
> ieee80211 phy0: Hardware restart was requested
> iwl3945 0000:03:00.0: BSM uCode verification failed at addr
> 0x00003800+0 (of 900), is 0xa5\
> a5a5a2, s/b 0xf802020
> iwl3945 0000:03:00.0: Unable to set up bootstrap uCode: -5
> 
> Best regards,
> 								Pavel
> 
> --

Huh - I don't remember any change there, but you should ask the right person - iwlegacy maintainer :)

