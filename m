Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752310AbaF3Fkv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 01:40:51 -0400
Received: from mail-ob0-f180.google.com ([209.85.214.180]:55861 "EHLO
	mail-ob0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751112AbaF3Fku (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 01:40:50 -0400
MIME-Version: 1.0
In-Reply-To: <20140629212144.GA12303@kroah.com>
References: <20140627095226.GA9420@devel.8.8.4.4>
	<20140629212144.GA12303@kroah.com>
Date: Mon, 30 Jun 2014 14:40:50 +0900
Message-ID: <CAHb8M2BNTr_sbJYe0HdxvG6Wi8ozpTM6zo0K+ntZ8tHfPmGQrQ@mail.gmail.com>
Subject: Re: [PATCH 1/3] staging: cxt1e1: Remove useless OS_phystov() and OS_vtophys()
From: DaeSeok Youn <daeseok.youn@gmail.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: devel <devel@driverdev.osuosl.org>, Shaun Laing <shaun@xresource.ca>,
        Wolfgang Ocker <weo@weo1.de>, "sachin.kamat" <sachin.kamat@linaro.org>,
        peter.p.waskiewicz.jr@intel.com,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Himangi Saraogi <himangi774@gmail.com>,
        Chekameh Cobbler <fempsci@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Greg.

2014-06-30 6:21 GMT+09:00 Greg KH <gregkh@linuxfoundation.org>:
> On Fri, Jun 27, 2014 at 06:52:26PM +0900, Daeseok Youn wrote:
>> OS_phystov()/OS_vtophys() are replaced with __va()/__pa().
>
> No, you should use virt_to_phys() and phys_to_virt() instead of these
> internal macros which might not be correct for all architectures.
OK, I will send this again after changing __pa/__va.
Thanks.

regards,
Daeseok Youn
>
> thanks,
>
> greg k-h
