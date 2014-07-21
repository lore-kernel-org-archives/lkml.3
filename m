Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752089AbaGUB4L (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jul 2014 21:56:11 -0400
Received: from mail-qc0-f169.google.com ([209.85.216.169]:35565 "EHLO
	mail-qc0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751641AbaGUB4J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jul 2014 21:56:09 -0400
MIME-Version: 1.0
In-Reply-To: <20140720180117.GA18951@electric-eye.fr.zoreil.com>
References: <1405655009-18975-1-git-send-email-ethan.zhao@oracle.com>
	<C562D0E12CBDE44E8A0CCAB77060096701283AD344@AVMB1.qlogic.org>
	<049BCC6F-0A2E-421A-9873-0B7ED6FFB3AC@gmail.com>
	<20140719101946.GA4319@electric-eye.fr.zoreil.com>
	<CABawtvP4+B_smOyi-=vt56KuUthzHF9L059PXP4ekXA7KPk_Dw@mail.gmail.com>
	<20140719162816.GB7590@electric-eye.fr.zoreil.com>
	<48774298-8C91-42A9-A5F2-4EAB789F356B@gmail.com>
	<20140720180117.GA18951@electric-eye.fr.zoreil.com>
Date: Mon, 21 Jul 2014 09:56:08 +0800
Message-ID: <CABawtvNrUqv4R4eacGZmjAm+X-RahurtJiE8XHRKKvptY+wNkw@mail.gmail.com>
Subject: Re: [PATCH V3] netxen: fix ethtool rx_dropped information in ethtool get_ethtool_stats()
From: Ethan Zhao <ethan.kernel@gmail.com>
To: Francois Romieu <romieu@fr.zoreil.com>
Cc: Rajesh Borundia <rajesh.borundia@qlogic.com>,
        Ethan Zhao <ethan.zhao@oracle.com>,
        Manish Chopra <manish.chopra@qlogic.com>,
        Sony Chacko <sony.chacko@qlogic.com>, netdev <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

---------- Forwarded message ----------
From: Francois Romieu <romieu@fr.zoreil.com>
Date: Mon, Jul 21, 2014 at 2:01 AM
Subject: Re: [PATCH V3] netxen: fix ethtool rx_dropped information in
ethtool get_ethtool_stats()
To: Ethan Zhao <ethan.kernel@gmail.com>
Cc: Rajesh Borundia <rajesh.borundia@qlogic.com>, Ethan Zhao
<ethan.zhao@oracle.com>, Manish Chopra <manish.chopra@qlogic.com>,
Sony Chacko <sony.chacko@qlogic.com>, netdev <netdev@vger.kernel.org>,
linux-kernel <linux-kernel@vger.kernel.org>


Ethan Zhao <ethan.kernel@gmail.com> :
[...]
> you leave us without a tool to track the net core part. Would you like to
> hack the kernel code and rebuild just for peek the dropping packets ?

Search 'dropwatch' on your favorite engine search.

That is a pretty good tool to trace and debug protocal stack when
packet dropping happens. but it is more professional and specific to
kernel kallsyms,
has some bugs to work well on  my box. yet another different tool to
output debug info while not statistic info.

I think drivers output rx dropped has their own reason.

[...]
> More radically, and maybe you should write patches to fix them to keep
> their focus. That is to prove you have principle and always fight for it.

It's 15 years late but it's still a good advice. :o)

Does it work ?

Thanks,
Ethan
--
Ueimor
