Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752421Ab3GHRaN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jul 2013 13:30:13 -0400
Received: from mga11.intel.com ([192.55.52.93]:13155 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751894Ab3GHRaL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jul 2013 13:30:11 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,1021,1363158000"; 
   d="scan'208";a="366971765"
From: "Luck, Tony" <tony.luck@intel.com>
To: Matt Fleming <matt@console-pimps.org>, "H. Peter Anvin" <hpa@zytor.com>
CC: Ingo Molnar <mingo@kernel.org>,
        "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [GIT PULL] EFI changes for v3.11
Thread-Topic: [GIT PULL] EFI changes for v3.11
Thread-Index: AQHOd8YdVwE3u4u7t0SZVLppTCgumZlbECfA
Date: Mon, 8 Jul 2013 17:29:59 +0000
Message-ID: <3908561D78D1C84285E8C5FCA982C28F31C76880@ORSMSX106.amr.corp.intel.com>
References: <20130626122331.GK22026@console-pimps.org>
 <20130703081903.GI25291@console-pimps.org>
In-Reply-To: <20130703081903.GI25291@console-pimps.org>
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

>> ----------------------------------------------------------------
>> Tony Luck (1):
>>       [IA64] sim: Add casts to avoid assignment warnings
>> 
>>  arch/ia64/hp/sim/boot/fw-emu.c | 20 ++++++++++----------
>>  1 file changed, 10 insertions(+), 10 deletions(-)
>
> I don't see this commit in Linus' tree so presumably Tony is still
> seeing these warnings.

Correct - I see 10 warning about "assignment makes pointer from integer"
when building Linus' tree (HEAD = d2b4a646).

My patch doesn't appear to be in linux-next either (next-20130708).

I had hoped to have this patch follow in the same path that the
one that changed the types and introduced the warnings took ...
but since that didn't work perhaps I should just ask Linus to pull
it from my ia64 tree.

-Tony
