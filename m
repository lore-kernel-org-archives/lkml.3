Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964821Ab3GLPKv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jul 2013 11:10:51 -0400
Received: from mail-qc0-f178.google.com ([209.85.216.178]:35618 "EHLO
	mail-qc0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932759Ab3GLPKu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jul 2013 11:10:50 -0400
MIME-Version: 1.0
In-Reply-To: <CAN1soZzuiukY9qASFNcH0k=zH8=uT=71bKejPss44FCzNy=X-A@mail.gmail.com>
References: <1373352166-10064-1-git-send-email-zhangwm@marvell.com>
	<1373352166-10064-2-git-send-email-zhangwm@marvell.com>
	<20130709124900.GG11908@titan.lakedaemon.net>
	<CAN1soZxiOh6TpbUOCUzK8gNwmvjbT3ihkUWaw8tuZ7md+NVA2g@mail.gmail.com>
	<20130710122433.GO11908@titan.lakedaemon.net>
	<CAN1soZzMvront1-jcBW6-uRKNs0OZNGnmiOjKGZSM28bViB_8A@mail.gmail.com>
	<20130710215041.GR11908@titan.lakedaemon.net>
	<CAN1soZzuiukY9qASFNcH0k=zH8=uT=71bKejPss44FCzNy=X-A@mail.gmail.com>
Date: Fri, 12 Jul 2013 09:10:49 -0600
X-Google-Sender-Auth: 9mETDGpZPYkAByN9I9t34LYTdXE
Message-ID: <CAMLZHHQGZvDssY-YxQ3ZW8FYhpG-H1-VbokOid33socRSPrMNw@mail.gmail.com>
Subject: Re: [PATCH V3 1/3] dts: change Marvell prefix to 'marvell'
From: Daniel Drake <dsd@laptop.org>
To: Haojian Zhuang <haojian.zhuang@gmail.com>
Cc: Jason Cooper <jason@lakedaemon.net>, Bergmann Arnd <arnd@arndb.de>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Grant Likely <grant.likely@linaro.org>,
        Neil Zhang <zhangwm@marvell.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 11, 2013 at 5:54 PM, Haojian Zhuang
<haojian.zhuang@gmail.com> wrote:
>> Well, Daniel Drake spoke up for OLPC.  Does that count?
>
> We don't know they used DT on Marvell MMP2/MMP3. So they don't have DTS file
> in kernel, we could use both old name & new name in driver.

You are listed as one of the MMP maintainers in the MAINTAINERS file
and I have sent you several patches in the few 3 weeks which make
OLPC's usage of MMP + DT pretty obvious. As a maintainer I believe you
are supposed to review the patches too. hint hint ;)

My request to avoid breaking compatibility actually comes as a
two-prong request.

I would prefer to see these compatible properties stay the same as it
seems like changing them has little purpose/benefit - and there *will*
become a later point where changing them causes major breakage.

At the same time I see that there have been recent efforts to remove
MMP2 platform code and make it entirely DT-driven, which could also
generate some compatibility concerns. However, such movements are much
appreciated and I think they will become increasingly necessary as we
bring up the devices on the MMP3 SoC to a fuller extent, so please
continue :) I would not want to discourage you from breaking
compatibility when *that* type of work needs to be done.


So: breaking compatibility is actually OK from my standpoint, but only
for now (while we stabilise), and I would advise/appreciate that it
only be done in cases where there is a clear purpose and benefit.

Daniel
