Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755316Ab3CSNQB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 09:16:01 -0400
Received: from mail-la0-f54.google.com ([209.85.215.54]:34749 "EHLO
	mail-la0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751644Ab3CSNP7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 09:15:59 -0400
MIME-Version: 1.0
X-Originating-IP: [109.186.17.83]
In-Reply-To: <81C3A93C17462B4BBD7E272753C10579248C0DF2EB@EXDCVYMBSTM005.EQ1STM.local>
References: <1360496352-29482-1-git-send-email-sjur.brandeland@stericsson.com>
 <1360496352-29482-2-git-send-email-sjur.brandeland@stericsson.com>
 <CAK=WgbYpTkjPsPRHO8is60SM-JR-LLCt8GK43mDAyBvt8EZP9w@mail.gmail.com> <81C3A93C17462B4BBD7E272753C10579248C0DF2EB@EXDCVYMBSTM005.EQ1STM.local>
From: Ohad Ben-Cohen <ohad@wizery.com>
Date: Tue, 19 Mar 2013 15:15:37 +0200
Message-ID: <CAK=WgbY0VfiOexaJLH1oBBzLKZSzOw88n5Y9N+4o_x+Cr0BJbA@mail.gmail.com>
Subject: Re: [PATCH 1/9] remoteproc: Bugfix: Deallocate firmware image on shutdown
To: Sjur BRENDELAND <sjur.brandeland@stericsson.com>
Cc: Ido Yariv <ido@wizery.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Dmitry TARNYAGIN <dmitry.tarnyagin@stericsson.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Erwan YVIN <erwan.yvin@stericsson.com>,
        =?ISO-8859-1?Q?Sjur_Br=E6ndeland?= <sjur@brendeland.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 19, 2013 at 2:40 PM, Sjur BRENDELAND
<sjur.brandeland@stericsson.com> wrote:
> Sure, you can add my:
> Signed-off-by: Sjur Brændeland <sjur.brandeland@stericsson.com>

Thanks. I'm also cc'ing stable
