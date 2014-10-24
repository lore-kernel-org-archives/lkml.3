Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752491AbaJXFBN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2014 01:01:13 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:37781 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750720AbaJXFBM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2014 01:01:12 -0400
Date: Fri, 24 Oct 2014 08:00:57 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Rom Lemarchand <romlem@android.com>
Cc: Arve =?iso-8859-1?B?SGr4bm5lduVn?= <arve@android.com>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        Anup Patel <anup.patel@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        John Stultz <john.stultz@linaro.org>,
        Christoffer Dall <christoffer.dall@linaro.org>,
        linux-api@vger.kernel.org, Rebecca Schultz Zavin <rebecca@android.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Sumit Semwal <sumit.semwal@linaro.org>
Subject: Re: [PATCH] staging: android: binder: move to the "real" part of the
 kernel
Message-ID: <20141024050056.GT23154@mwanda>
References: <20141016124741.GA3832@kroah.com>
 <20141017092601.GH23154@mwanda>
 <20141019220547.GC3780@kroah.com>
 <20141020092049.GJ23154@mwanda>
 <CAMP5Xgcm-sxd3rf3VA1ZO44bUT1+u_QG1AAdjzK39q0ynfsZGQ@mail.gmail.com>
 <CAABpnA8Oe9_8r9hyAQADPwNh4Zn63tUQAUD7f0WSYh1xcdtz6g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAABpnA8Oe9_8r9hyAQADPwNh4Zn63tUQAUD7f0WSYh1xcdtz6g@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 21, 2014 at 08:10:32PM -0700, Rom Lemarchand wrote:
> We would also like to make kernel-team@android.com the maintainer of
> the whole android directory.

Mailing lists can't be a maintainer, but you could add it as a private
list in the MAINTAINERS file.

regards,
dan carpenter

