Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756868Ab3H3XF5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Aug 2013 19:05:57 -0400
Received: from mga11.intel.com ([192.55.52.93]:6210 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753853Ab3H3XF4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Aug 2013 19:05:56 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,994,1367996400"; 
   d="scan'208";a="394737423"
From: "Luck, Tony" <tony.luck@intel.com>
To: Kees Cook <keescook@chromium.org>, Maxime Bizon <mbizon@freebox.fr>
CC: Anton Vorontsov <anton@enomsg.org>, Colin Cross <ccross@android.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] pstore/ram: (really) fix undefined usage of
 rounddown_pow_of_two
Thread-Topic: [PATCH] pstore/ram: (really) fix undefined usage of
 rounddown_pow_of_two
Thread-Index: AQHOpZsFV70POy9UR0iXLYLxNNNMtZmuhAuA///bbPA=
Date: Fri, 30 Aug 2013 23:05:54 +0000
Message-ID: <3908561D78D1C84285E8C5FCA982C28F31CD4884@ORSMSX106.amr.corp.intel.com>
References: <1377878801.559.28.camel@sakura.staff.proxad.net>
 <CAGXu5jLfHMw=sd0OBSTjJy5ffqrD8s6BsVv+4iA6=jzUG89dpw@mail.gmail.com>
In-Reply-To: <CAGXu5jLfHMw=sd0OBSTjJy5ffqrD8s6BsVv+4iA6=jzUG89dpw@mail.gmail.com>
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

>> Previous attempt to fix was b042e47491ba5f487601b5141a3f1d8582304170
>>
>> Suggested use of is_power_of_2() was bogus because is_power_of_2(0) is
>> false (documented behaviour).
>>
>> Signed-off-by: Maxime Bizon <mbizon@freebox.fr>
>
> Yes, excellent point. :)
>
> Acked-by: Kees Cook <keescook@chromium.org>

Applied.  Thanks.

-Tony
