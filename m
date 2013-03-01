Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752662Ab3CAIji (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Mar 2013 03:39:38 -0500
Received: from mail-ie0-f175.google.com ([209.85.223.175]:49091 "EHLO
	mail-ie0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751346Ab3CAIjh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Mar 2013 03:39:37 -0500
MIME-Version: 1.0
In-Reply-To: <78fd1c1df13b449887de6e0b3505a988@DFM-DB3MBX15-06.exchange.corp.microsoft.com>
References: <20130228083437.GA28143@lnx-rg> <78fd1c1df13b449887de6e0b3505a988@DFM-DB3MBX15-06.exchange.corp.microsoft.com>
From: Richard Genoud <richard.genoud@gmail.com>
Date: Fri, 1 Mar 2013 09:39:16 +0100
Message-ID: <CACQ1gAgyYp+Dxmk-0C3zfKK+CkEwQX51NvWjzkV7=8GC3CD=Qg@mail.gmail.com>
Subject: Re: hv_netvsc: WARNING in softirq.c
To: Haiyang Zhang <haiyangz@microsoft.com>
Cc: KY Srinivasan <kys@microsoft.com>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/2/28 Haiyang Zhang <haiyangz@microsoft.com>:
> We will look into this. And further info around the time will also be helpful.
>
> Thanks,
> - Haiyang

The only thing the admin sys could think about is a rsync process
between the windows host and ANOTHER linux guest that ends at 22h30
more or less.
(the other linux guest is a debian 6, without any HV driver)


-- 
for me, ck means con kolivas and not calvin klein... does it mean I'm a geek ?
