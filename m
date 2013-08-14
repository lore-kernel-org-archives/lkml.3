Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760045Ab3HNR7O (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 13:59:14 -0400
Received: from mga14.intel.com ([143.182.124.37]:39549 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758344Ab3HNR7N convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 13:59:13 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,878,1367996400"; 
   d="scan'208";a="346399426"
From: "Luck, Tony" <tony.luck@intel.com>
To: Kees Cook <keescook@chromium.org>,
        Dan Carpenter <dan.carpenter@oracle.com>
CC: Anton Vorontsov <anton@enomsg.org>, Colin Cross <ccross@android.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>
Subject: RE: [patch] pstore: d_alloc_name() doesn't return an ERR_PTR
Thread-Topic: [patch] pstore: d_alloc_name() doesn't return an ERR_PTR
Thread-Index: AQHOmOTF4jED9cYuBEebKzNeUfEQGpmVN7CA///GT4A=
Date: Wed, 14 Aug 2013 17:59:10 +0000
Message-ID: <3908561D78D1C84285E8C5FCA982C28F31CBAA1E@ORSMSX106.amr.corp.intel.com>
References: <20130814115218.GC8044@elgon.mountain>
 <CAGXu5j+tSY1MPTV383ij6Jgqf+dq+QVDtpcWdXmgNKL8gpc5zQ@mail.gmail.com>
In-Reply-To: <CAGXu5j+tSY1MPTV383ij6Jgqf+dq+QVDtpcWdXmgNKL8gpc5zQ@mail.gmail.com>
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

>> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
>
> Thanks for the catch!
>
> Acked-by: Kees Cook <keescook@chromium.org>

Thanks.  Applied.

-Tony
