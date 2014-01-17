Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752263AbaAQOzq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jan 2014 09:55:46 -0500
Received: from mga09.intel.com ([134.134.136.24]:34498 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750898AbaAQOzm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jan 2014 09:55:42 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,674,1384329600"; 
   d="scan'208";a="468284558"
From: "Dorau, Lukasz" <lukasz.dorau@intel.com>
To: Richard Weinberger <richard.weinberger@gmail.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: RE: Why is (2 < 2) true? Is it a gcc bug?
Thread-Topic: Why is (2 < 2) true? Is it a gcc bug?
Thread-Index: Ac8TiNMTmnptR9ryRvWTI5/er276UQAA1SoAAAH3iWA=
Date: Fri, 17 Jan 2014 14:55:39 +0000
Message-ID: <D9FFE20C522965449E182ACE73889AEB1A6A3592@IRSMSX105.ger.corp.intel.com>
References: <D9FFE20C522965449E182ACE73889AEB1A6A340F@IRSMSX105.ger.corp.intel.com>
 <CAFLxGvz3FKU4rgjF_uZsggjvw8TQw_Hcp42GC8Zr-wg5kiwc-w@mail.gmail.com>
In-Reply-To: <CAFLxGvz3FKU4rgjF_uZsggjvw8TQw_Hcp42GC8Zr-wg5kiwc-w@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [163.33.239.181]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, January 17, 2014 2:58 PM Richard Weinberger <richard.weinberger@gmail.com> wrote:
> 
> Can you reproduce this using a standalone test?
> I.e:
> #include <assert.h>
> 
> int main()
> {
>         assert(2 < 2 != 1);
> 
>         return 0;
> }
> 

No, I can't of course.

Lukasz

