Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755646Ab3HRW5R (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Aug 2013 18:57:17 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:40367 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754996Ab3HRW5Q convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Aug 2013 18:57:16 -0400
From: "Kim, Milo" <Milo.Kim@ti.com>
To: Bryan Wu <cooloney@gmail.com>
CC: =?iso-8859-1?Q?Pali_Roh=E1r?= <pali.rohar@gmail.com>,
        Linux LED Subsystem <linux-leds@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>, Milo Kim <woogyom.kim@gmail.com>
Subject: RE: [PATCH 01/10] leds: lp55xx: add common data structure for
 program
Thread-Topic: [PATCH 01/10] leds: lp55xx: add common data structure for
 program
Thread-Index: AQHOlA1Xw1EX7CXaFUe1LSqTxFyADZmS/1oAgAijZtA=
Date: Sun, 18 Aug 2013 22:57:09 +0000
Message-ID: <A874F61F95741C4A9BA573A70FE3998F82E888D0@DQHE06.ent.ti.com>
References: <1375948794-6286-1-git-send-email-milo.kim@ti.com>
 <1375948794-6286-2-git-send-email-milo.kim@ti.com>
 <CAK5ve-K10M3+=ctxu+5hU=pPz1_x6p1JgQS6jEin-LfxnP8Hog@mail.gmail.com>
In-Reply-To: <CAK5ve-K10M3+=ctxu+5hU=pPz1_x6p1JgQS6jEin-LfxnP8Hog@mail.gmail.com>
Accept-Language: en-US, ko-KR
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.16.34.32]
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Bryan,

> -----Original Message-----
> From: Bryan Wu [mailto:cooloney@gmail.com]
> Sent: Wednesday, August 14, 2013 3:56 AM
> To: Milo Kim
> Cc: Pali Rohár; Linux LED Subsystem; lkml; Kim, Milo
> Subject: Re: [PATCH 01/10] leds: lp55xx: add common data structure for
> program
> 
> On Thu, Aug 8, 2013 at 12:59 AM, Milo Kim <woogyom.kim@gmail.com> wrote:
> > LP55xx family devices have internal three program engines which are
> > used for loading LED patterns.
> > To maintain legacy device attributes, specific data structure is used,
> 'mode'
> > and 'led_mux'.
> > The mode is used for showing/storing current engine mode such like
> > disabled, load and run.
> > Then led_mux is used for showing/storing current output LED selection.
> > This is only for LP5523/55231.
> >
> 
> This patch looks good to me, but the commit message format is little bit odd
> to me. I will fix that and merge into my tree.

Thanks for your help.
Can I get more detailed information about this format problem?
I need to check my configurations.

Thanks,
Milo-
