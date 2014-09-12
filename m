Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752746AbaILVti (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 17:49:38 -0400
Received: from mail-ie0-f169.google.com ([209.85.223.169]:36724 "EHLO
	mail-ie0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751056AbaILVtf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 17:49:35 -0400
MIME-Version: 1.0
In-Reply-To: <gh4mwcef0r.fsf@quad.gouders.net>
References: <ghiol53r9u.fsf@lena.gouders.net>
	<CAMxnaaXiEZeJOsgQ6ZSbiqy5Z1zNoXonwNSQNRyRhV0t5jveYQ@mail.gmail.com>
	<ghwq9k3m6z.fsf@lena.gouders.net>
	<CAMxnaaUqTMf1uEQUqrAGjym8ZrQaBf2QbE4Jqxh2t6a2JgJkOQ@mail.gmail.com>
	<ghioku5l29.fsf@lena.gouders.net>
	<CAErSpo7j=a3y2MVsvEQGQ4B63_mNCyZSRNXNEZa-2++xs88NmQ@mail.gmail.com>
	<CAE9FiQUXvuZo2bQSRg0vpuDVYrnkcXDu7KZBNp-YgXbKa2LQhw@mail.gmail.com>
	<ghppf15236.fsf@quad.gouders.net>
	<CAErSpo5SVUOz+qa_x5JTC+-Y5ewTyYzA0N=jyPtK9LaguRrt=w@mail.gmail.com>
	<ghd2b1svdw.fsf@quad.gouders.net>
	<CAErSpo5e0GOdVbZdQYriP+aWziKELpb9BWTgJ4ERPia354CM5w@mail.gmail.com>
	<ghvbotd8es.fsf@quad.gouders.net>
	<ghzje5f5zt.fsf@lena.gouders.net>
	<ghbnqkeh9k.fsf@quad.gouders.net>
	<CAE9FiQXQesrDMqf1b6ZhHdmY_wEEUrOEvNO4N_d6WtaNMGNLww@mail.gmail.com>
	<gh4mwcef0r.fsf@quad.gouders.net>
Date: Fri, 12 Sep 2014 14:49:34 -0700
X-Google-Sender-Auth: I4pUGu_E9UgthTk2kUTcOYODKes
Message-ID: <CAE9FiQWgioBeVmfWCaE38BrkjbWKaS+_FYYdmdd+7X8fpeEgnQ@mail.gmail.com>
Subject: Re: [BUG] Bisected Problem with LSI PCI FC Adapter
From: Yinghai Lu <yinghai@kernel.org>
To: Dirk Gouders <dirk@gouders.net>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andreas Noever <andreas.noever@gmail.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 12, 2014 at 1:54 PM, Dirk Gouders <dirk@gouders.net> wrote:
> Yinghai Lu <yinghai@kernel.org> writes:
>
>> On Fri, Sep 12, 2014 at 1:05 PM, Dirk Gouders <dirk@gouders.net> wrote:
>>> Dirk Gouders <dirk@gouders.net> writes:
> -[0000:00]-+-01.0-[01-02]--+-0d.0-[02]--
>            |               +-0e.0  Broadcom BCM5785 [HT1000] SATA (PATA/IDE Mode)
>            |               \-0e.1  Broadcom BCM5785 [HT1000] SATA (PATA/IDE Mode)
>            +-02.0  Broadcom BCM5785 [HT1000] Legacy South Bridge
>            +-02.1  Broadcom BCM5785 [HT1000] IDE
>            +-02.2  Broadcom BCM5785 [HT1000] LPC
>            +-03.0  Broadcom BCM5785 [HT1000] USB
>            +-03.1  Broadcom BCM5785 [HT1000] USB
>            +-03.2  Broadcom BCM5785 [HT1000] USB
>            +-06.0-[03]--
>            +-07.0-[04]--+-04.0  Broadcom Corporation NetXtreme BCM5780 Gigabit Ethernet
>            |            \-04.1  Broadcom Corporation NetXtreme BCM5780 Gigabit Ethernet
>            +-0a.0-[05]--
>            +-0b.0-[06]--

what is "lspci -tv" and "lspci -vvxxx" look like before your patch that cut down
end bus to 07 ...?

Thanks

Yinghai
