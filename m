Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754776Ab3CSMuE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 08:50:04 -0400
Received: from eu1sys200aog112.obsmtp.com ([207.126.144.133]:38340 "EHLO
	eu1sys200aog112.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754146Ab3CSMuC convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 08:50:02 -0400
From: Sjur BRENDELAND <sjur.brandeland@stericsson.com>
To: Ohad Ben-Cohen <ohad@wizery.com>
Cc: Ido Yariv <ido@wizery.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Dmitry TARNYAGIN <dmitry.tarnyagin@stericsson.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Erwan YVIN <erwan.yvin@stericsson.com>,
        =?iso-8859-1?Q?Sjur_Br=E6ndeland?= <sjur@brendeland.net>
Date: Tue, 19 Mar 2013 13:40:19 +0100
Subject: RE: [PATCH 1/9] remoteproc: Bugfix: Deallocate firmware image on
 shutdown
Thread-Topic: [PATCH 1/9] remoteproc: Bugfix: Deallocate firmware image on
 shutdown
Thread-Index: Ac4knpSymovp6N4DTQS7nnPxTXpYAgAAAu+w
Message-ID: <81C3A93C17462B4BBD7E272753C10579248C0DF2EB@EXDCVYMBSTM005.EQ1STM.local>
References: <1360496352-29482-1-git-send-email-sjur.brandeland@stericsson.com>
 <1360496352-29482-2-git-send-email-sjur.brandeland@stericsson.com>
 <CAK=WgbYpTkjPsPRHO8is60SM-JR-LLCt8GK43mDAyBvt8EZP9w@mail.gmail.com>
In-Reply-To: <CAK=WgbYpTkjPsPRHO8is60SM-JR-LLCt8GK43mDAyBvt8EZP9w@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ohad,

> On Sun, Feb 10, 2013 at 1:39 PM,  <sjur.brandeland@stericsson.com> wrote:
> > From: Dmitry Tarnyagin <dmitry.tarnyagin@stericsson.com>
> >
> > Fixes coherent memory leakage, caused by non-deallocated
> > firmware image chunk.
> 
> I'll just slightly edit the subject + commit log to indicate this fix
> is STE-specific.

Sure, no problem.

> 
> > Signed-off-by: Dmitry Tarnyagin <dmitry.tarnyagin@stericsson.com>
> 
> Can I add your s-o-b here?
> 
> Since you sent the patch, we should add your s-o-b after Dmitry's.

Sure, you can add my: 
Signed-off-by: Sjur Brændeland <sjur.brandeland@stericsson.com>

Thanks,
Sjur
