Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754682AbaGIMOM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 08:14:12 -0400
Received: from TYO201.gate.nec.co.jp ([210.143.35.51]:50257 "EHLO
	tyo201.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751300AbaGIMOK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 08:14:10 -0400
From: Junichi Nomura <j-nomura@ce.jp.nec.com>
To: "aik@ozlabs.ru" <aik@ozlabs.ru>
CC: device-mapper development <dm-devel@redhat.com>,
        Mike Snitzer <snitzer@redhat.com>, Paul Mackerras <paulus@samba.org>,
        Vladimir Davydov <vdavydov@parallels.com>,
        "bvanassche@acm.org" <bvanassche@acm.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linuxppc-dev@ozlabs.org" <linuxppc-dev@ozlabs.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [dm-devel] Regression in 3.15 on POWER8 with multipath SCSI
Thread-Topic: [dm-devel] Regression in 3.15 on POWER8 with multipath SCSI
Thread-Index: AQHPmpdSO1G1Y6CCYUGnzA1eamu97ZuWhy0AgACLEYA=
Date: Wed, 9 Jul 2014 12:13:12 +0000
Message-ID: <11AF7C027C4C02408624617A498607840132A448@BPXM12GP.gisp.nec.co.jp>
References: <20140630103058.GA17747@iris.ozlabs.ibm.com>
	<20140701193907.GA15306@redhat.com>
	<11AF7C027C4C02408624617A4986078401323542@BPXM12GP.gisp.nec.co.jp>
 <53BCBD2E.6010203@ozlabs.ru>
In-Reply-To: <53BCBD2E.6010203@ozlabs.ru>
Accept-Language: ja-JP, en-US
Content-Language: ja-JP
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.34.125.85]
Content-Type: text/plain; charset="iso-2022-jp"
Content-ID: <E788EF8EB185CE4FB3CC1C4BFB636B71@gisp.nec.co.jp>
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/09/14 12:55, Alexey Kardashevskiy wrote:
> On 07/08/2014 08:28 PM, Junichi Nomura wrote:
>> It seems Bart's issue has gone with the attached patch:
>> http://www.redhat.com/archives/dm-devel/2014-July/msg00035.html
>> Could you try if it makes any difference on your issue?
..
> This patch fixes IPR SCSI for my POWER8 box, e8099177 was the problem.

Thank you for the testing.

Mike Snitzer has picked up this patch for his tree:
https://git.kernel.org/cgit/linux/kernel/git/device-mapper/linux-dm.git/commit/?h=for-next&id=75c76c45b76e53b7c2f025d30e7e308bfe331004

-- 
Jun'ichi Nomura, NEC Corporation
