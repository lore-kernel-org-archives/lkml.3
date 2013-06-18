Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933385Ab3FRUCD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 16:02:03 -0400
Received: from na3sys009aog129.obsmtp.com ([74.125.149.142]:47528 "EHLO
	na3sys009aog129.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932861Ab3FRUCB convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 16:02:01 -0400
From: Bing Zhao <bzhao@marvell.com>
To: Doug Anderson <dianders@chromium.org>
CC: Seungwon Jeon <tgih.jun@samsung.com>,
        Jaehoon Chung <jh80.chung@samsung.com>, Chris Ball <cjb@laptop.org>,
        Will Newton <will.newton@gmail.com>,
        Ashok Nagarajan <asnagarajan@chromium.org>,
        Paul Stewart <pstew@chromium.org>, Olof Johansson <olof@lixom.net>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Tue, 18 Jun 2013 13:01:16 -0700
Subject: RE: [PATCH] RFC: mmc: dw_mmc: Always go to STATE_DATA_BUSY from
 STATE_DATA_ERROR
Thread-Topic: [PATCH] RFC: mmc: dw_mmc: Always go to STATE_DATA_BUSY from
 STATE_DATA_ERROR
Thread-Index: Ac5sXWPDZL00mT1sST6ci17YV8UTzQAAGJyg
Message-ID: <477F20668A386D41ADCC57781B1F70430EA2AA251A@SC-VEXCH1.marvell.com>
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
In-Reply-To: <CAD=FV=Xz-Cp86u=w8m91AEMJgH-o6cLkz6_udVw_3bm7Tm0OiA@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Doug,

> > I tested Doug's patch on my failing unit.
> >
> > Without this patch, mmc got hung_task and rebooted eventually.
> > With this patch applied, mmc returns CRC error instead of hung_task, and the error is handled
> gracefully.
> 
> Have you tried one or both or Seungwon's fixes without mine?

I only tested your original patch. That was several months ago I think.

I still have that unit. Let me know if you want me to try Seungwon's patches.

Thanks,
Bing

> 
> -Doug
