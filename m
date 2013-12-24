Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752335Ab3LXRw0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Dec 2013 12:52:26 -0500
Received: from mail-ie0-f179.google.com ([209.85.223.179]:53015 "EHLO
	mail-ie0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752182Ab3LXRwY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Dec 2013 12:52:24 -0500
MIME-Version: 1.0
In-Reply-To: <CACaajQv1OWxxcGORBq=LN-4JQzATf4YmWBQymoeyovfY-rUpmw@mail.gmail.com>
References: <CACaajQv1OWxxcGORBq=LN-4JQzATf4YmWBQymoeyovfY-rUpmw@mail.gmail.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Tue, 24 Dec 2013 10:52:02 -0700
Message-ID: <CAErSpo4uZ1N7uKyKMGHERtq-gvcpQ7oHTE7U9fGiAzfziMJ+Ew@mail.gmail.com>
Subject: Re: tg3 and sd card reader at acer aspire
To: Vasiliy Tolstov <v.tolstov@selfip.ru>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[+cc linux-pci because I think this is related to PCI ASPM]

I'm afraid nobody wants to touch ASPM because it's such a mess, but I
hope somebody will step up and investigate this.

On Tue, Dec 24, 2013 at 1:27 AM, Vasiliy Tolstov <v.tolstov@selfip.ru> wrote:
> Hi all and sorry for may be spamming mailing list.
>
> I have acer aspire v5-17 with broadcom card reader and ethernet card.
> I'm affecting on this ubuntu bugs. But bug is present in vanilla linux
> current git and stable lts.
>
> Can somebody helps me and say - where i can post message and discuss
> this problem. As i see ubuntu team can't solve this problem (bug
> present is about 1 year and nothing changed).
> One ubuntu user wia bisecting find broken commit -
> https://git.kernel.org/cgit/linux/kernel/git/stable/linux-stable.git/commit/?id=6cac12dfab9c57a4f76821412224b226a9b08dff
>
> Relevant ubuntu bugs:
> https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1178131
> https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1067222
>
>
> Thanks!
> --
> Vasiliy Tolstov,
> e-mail: v.tolstov@selfip.ru
> jabber: vase@selfip.ru
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
