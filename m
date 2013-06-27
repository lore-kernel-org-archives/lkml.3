Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754081Ab3F0STO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jun 2013 14:19:14 -0400
Received: from na3sys009aog135.obsmtp.com ([74.125.149.84]:57079 "EHLO
	na3sys009aog135.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753961Ab3F0STN convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jun 2013 14:19:13 -0400
From: Bing Zhao <bzhao@marvell.com>
To: Jaehoon Chung <jh80.chung@samsung.com>,
        Seungwon Jeon <tgih.jun@samsung.com>
CC: "'Doug Anderson'" <dianders@chromium.org>, "'Chris Ball'" <cjb@laptop.org>,
        "'Will Newton'" <will.newton@gmail.com>,
        "'Ashok Nagarajan'" <asnagarajan@chromium.org>,
        "'Paul Stewart'" <pstew@chromium.org>,
        "'Olof Johansson'" <olof@lixom.net>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Thu, 27 Jun 2013 11:18:21 -0700
Subject: RE: [PATCH] RFC: mmc: dw_mmc: Always go to STATE_DATA_BUSY from
 STATE_DATA_ERROR
Thread-Topic: [PATCH] RFC: mmc: dw_mmc: Always go to STATE_DATA_BUSY from
 STATE_DATA_ERROR
Thread-Index: Ac5y53nyD5tZKIjORd+T3h0sT5XeKwAeqvrQ
Message-ID: <477F20668A386D41ADCC57781B1F70430EA2CE594E@SC-VEXCH1.marvell.com>
References: <1363382956-14557-1-git-send-email-dianders@chromium.org>
 <5146EAB0.1030705@samsung.com>
 <CAD=FV=Ww-iK=-vg4jnJe6w4836-yQUoUyxNvCYsDQ5w0q-OMMQ@mail.gmail.com>
 <515E88E3.5070507@samsung.com>
 <003401ce3453$19d1e8c0$4d75ba40$%jun@samsung.com>
 <CAD=FV=V+ZZ0MUtuWKUOgR9NPyAquUjFC6KtHvAP-4iHXAYpjqA@mail.gmail.com>
 <001601ce35b9$652c5870$2f850950$%jun@samsung.com>
 <CAD=FV=XKeRjpH1+ytjMfLuGGqQ5VVub22n=V+UpV=jBCD4LLHw@mail.gmail.com>
 <001801ce6c20$6ba39900$42eacb00$%jun@samsung.com>
 <477F20668A386D41ADCC57781B1F70430EA2AA2513@SC-VEXCH1.marvell.com>
 <CAD=FV=Xz-Cp86u=w8m91AEMJgH-o6cLkz6_udVw_3bm7Tm0OiA@mail.gmail.com>
 <477F20668A386D41ADCC57781B1F70430EA2AA251A@SC-VEXCH1.marvell.com>
 <CAD=FV=V6S7FsK+=+7EHDV74=Mw_iWecO2ZxVpVcd=p7ugW-sHA@mail.gmail.com>
 <477F20668A386D41ADCC57781B1F70430EA2BD5ECB@SC-VEXCH1.marvell.com>
 <001001ce720f$f96980c0$ec3c8240$%jun@samsung.com>
 <51CBB332.2050903@samsung.com>
In-Reply-To: <51CBB332.2050903@samsung.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> I didn't get the same result..In my case, it's working fine.
> But as Bing's result, i will check more and share the result.

I want to add that my kernel is from "cros/release-R26-3701.B" branch with this HEAD:

4e13a9c CHERRY-PICK: UPSTREAM: loop: prevent bdev freeing while device in use

Thanks,
Bing
