Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755743Ab3LDCTc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 21:19:32 -0500
Received: from mail-ie0-f172.google.com ([209.85.223.172]:40404 "EHLO
	mail-ie0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753505Ab3LDCT3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 21:19:29 -0500
MIME-Version: 1.0
In-Reply-To: <2691826.V0kc3nrim3@vostro.rjw.lan>
References: <1385851238-21085-1-git-send-email-yinghai@kernel.org>
	<1385851238-21085-5-git-send-email-yinghai@kernel.org>
	<2691826.V0kc3nrim3@vostro.rjw.lan>
Date: Tue, 3 Dec 2013 18:19:28 -0800
X-Google-Sender-Auth: QOmjhYwIPZesxLFfkjaRiKoC-Ro
Message-ID: <CAE9FiQUURT40gXGFhPxqHvWTxVdWbm=70uh14U=dp=FgTOGt-g@mail.gmail.com>
Subject: Re: [PATCH v3 04/12] PCI: Destroy pci dev only once
From: Yinghai Lu <yinghai@kernel.org>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Gu Zheng <guz.fnst@cn.fujitsu.com>, Guo Chao <yan@linux.vnet.ibm.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 30, 2013 at 5:05 PM, Rafael J. Wysocki <rjw@rjwysocki.net> wrote:
> On Saturday, November 30, 2013 02:40:30 PM Yinghai Lu wrote:
>
> And this is not enough as I said, can you please stop ignoring me openly?
>
> You've already commented the last patch I posted, so why don't we finish
> that discussion first?

No, i did not mean that.

I resent the whole patchset as I added pci_clip_resource() and that
will need to revise several critial patches, and Bjorn does not like
to have patches to be attached format.

Also in the patcheset head mail, i did state that you have another
solution using
lock.

And your patch is quite big, please give me some time to digest it.

Thanks

Yinghai
