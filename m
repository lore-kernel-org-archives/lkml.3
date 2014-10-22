Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753462AbaJVDKf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 23:10:35 -0400
Received: from mail-qa0-f45.google.com ([209.85.216.45]:50320 "EHLO
	mail-qa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751233AbaJVDKd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 23:10:33 -0400
MIME-Version: 1.0
In-Reply-To: <CAMP5Xgcm-sxd3rf3VA1ZO44bUT1+u_QG1AAdjzK39q0ynfsZGQ@mail.gmail.com>
References: <20141016124741.GA3832@kroah.com>
	<20141017092601.GH23154@mwanda>
	<20141019220547.GC3780@kroah.com>
	<20141020092049.GJ23154@mwanda>
	<CAMP5Xgcm-sxd3rf3VA1ZO44bUT1+u_QG1AAdjzK39q0ynfsZGQ@mail.gmail.com>
Date: Tue, 21 Oct 2014 20:10:32 -0700
X-Google-Sender-Auth: sfuIvKrvLblWZHUKUh4ePkb1upo
Message-ID: <CAABpnA8Oe9_8r9hyAQADPwNh4Zn63tUQAUD7f0WSYh1xcdtz6g@mail.gmail.com>
Subject: Re: [PATCH] staging: android: binder: move to the "real" part of the kernel
From: Rom Lemarchand <romlem@android.com>
To: =?UTF-8?B?QXJ2ZSBIasO4bm5ldsOlZw==?= <arve@android.com>
Cc: Dan Carpenter <dan.carpenter@oracle.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        Anup Patel <anup.patel@linaro.org>, linux-api@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        John Stultz <john.stultz@linaro.org>,
        Rebecca Schultz Zavin <rebecca@android.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        Christoffer Dall <christoffer.dall@linaro.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On the topic of maintainers for binder: both Arve Hjønnevåg
(arve@android.com) and Riley Andrews (riandrews@android.com) have
volunteered to be co-maintainers with Greg.

We would also like to make kernel-team@android.com the maintainer of
the whole android directory.
