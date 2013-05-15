Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752408Ab3EOVbe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 May 2013 17:31:34 -0400
Received: from gate.crashing.org ([63.228.1.57]:32973 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751020Ab3EOVbb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 May 2013 17:31:31 -0400
Message-ID: <1368653371.9603.18.camel@pasglop>
Subject: Re: [PATCH v2, part 1 3/9] PCI: Convert alloc_pci_dev(void) to
 pci_alloc_dev(bus) instead
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Liu Jiang <liuj97@gmail.com>
Cc: Yinghai Lu <yinghai@kernel.org>, Gu Zheng <guz.fnst@cn.fujitsu.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        "Rafael J . Wysocki" <rjw@sisk.pl>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Toshi Kani <toshi.kani@hp.com>, Myron Stowe <myron.stowe@redhat.com>,
        Yijing Wang <wangyijing@huawei.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        "David S. Miller" <davem@davemloft.net>,
        David Airlie <airlied@linux.ie>,
        Neela Syam Kolli <megaraidlinux@lsi.com>,
        "James E.J. Bottomley" <jbottomley@parallels.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linuxppc-dev@lists.ozlabs.org,
        "sparclinux@vger.kernel.org" <sparclinux@vger.kernel.org>,
        Linux-Scsi <linux-scsi@vger.kernel.org>,
        Jiang Liu <jiang.liu@huawei.com>
Date: Thu, 16 May 2013 07:29:31 +1000
In-Reply-To: <51939FB1.20203@gmail.com>
References: <1368461313-4371-1-git-send-email-jiang.liu@huawei.com>
	 <1368461313-4371-4-git-send-email-jiang.liu@huawei.com>
	 <CAE9FiQVKKKmZRQ8CcKCzU8Gqzwb5SjWYagVB2OZiRqbSWXVpiw@mail.gmail.com>
	 <5191F53E.4000305@cn.fujitsu.com> <51925136.5050302@gmail.com>
	 <CAE9FiQWO-jR5y35kKiW0m6gVR54ZyRsBsdhP4BmFLSsDzCS3rA@mail.gmail.com>
	 <51926CF6.1050706@gmail.com>
	 <CAE9FiQWXN_ETRFPb5oFx-6LXyuHviX3h3NXCQKjcxtv2Uma-JA@mail.gmail.com>
	 <51939E16.9090105@gmail.com>
	 <CAE9FiQUXrOmN0rkvOwE1G_acEGY3-gouzaXjBMT7EE6uAqvuZA@mail.gmail.com>
	 <51939FB1.20203@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-05-15 at 22:46 +0800, Liu Jiang wrote:
>        I don't know any OF exports, could you please help to CC
> some OF experts?

I wrote that code I think. Sorry, I've missed the beginning of the
thread, what is the problem ?

Cheers,
Ben.


