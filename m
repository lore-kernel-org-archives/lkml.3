Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752737Ab3FNMoQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jun 2013 08:44:16 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:37271 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752579Ab3FNMoM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jun 2013 08:44:12 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Alexander E. Patrakov" <patrakov@gmail.com>
Cc: Jiang Liu <jiang.liu@huawei.com>, Bjorn Helgaas <bhelgaas@google.com>,
        Yinghai Lu <yinghai@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Yijing Wang <wangyijing@huawei.com>, Jiang Liu <liuj97@gmail.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        stable@vger.kernel.org
Subject: Re: [BUGFIX 2/9] ACPIPHP: fix device destroying order issue when handling dock notification
Date: Fri, 14 Jun 2013 14:53:26 +0200
Message-ID: <6382542.YexNMucoL5@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.10.0-rc5+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <CAN_LGv1_b16XDAS-hrP2w=ERBgJ+V+P3kgKrksR0qO3navXiOg@mail.gmail.com>
References: <1371141152-9468-1-git-send-email-jiang.liu@huawei.com> <2301639.HY0nSRLtah@vostro.rjw.lan> <CAN_LGv1_b16XDAS-hrP2w=ERBgJ+V+P3kgKrksR0qO3navXiOg@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, June 14, 2013 06:30:58 PM Alexander E. Patrakov wrote:
> 2013/6/14 Rafael J. Wysocki <rjw@sisk.pl>:
> 
> > What about the appended patch (on top of [1/9], untested)?
> >
> > Rafael
> 
> Sorry, I have lost the track of which patches, on top of 3.10-rc5, I
> should include in my testing and which I shouldn't. Could you please
> restore my understanding? I.e., please provide a full list of LKML or
> Bugzilla links to patches which I should test during the next boot of
> the laptop.
> 
> Thanks in advance.

As far as I'm concerned, please test these two for now:

https://patchwork.kernel.org/patch/2717851/
https://patchwork.kernel.org/patch/2721271/

They are targeted at the ordering problems only, however, so they won't address
the resource allocation issues you're seeing.

There are some other patches Jiang Liu and Yinghai are working on as far as
I can say, but I'm not sure what their status is at the moment.

Thanks,
Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
