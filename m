Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752600Ab3KOQJX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Nov 2013 11:09:23 -0500
Received: from mail-ob0-f180.google.com ([209.85.214.180]:37521 "EHLO
	mail-ob0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752099Ab3KOQJO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Nov 2013 11:09:14 -0500
MIME-Version: 1.0
In-Reply-To: <CA+r1ZhiPW29tUDYNyEt36jWgYKpt1tXALRGVzrOza5X+J+awXA@mail.gmail.com>
References: <CA+r1ZhiPW29tUDYNyEt36jWgYKpt1tXALRGVzrOza5X+J+awXA@mail.gmail.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Fri, 15 Nov 2013 09:08:53 -0700
Message-ID: <CAErSpo5dhJRMcg7RMKNAQoE5ELeby2ULKFUhw2ncyaML8-+jvw@mail.gmail.com>
Subject: Re: randconfig build error with next-20131115, in drivers/pci/hotplug
To: Jim Davis <jim.epost@gmail.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
        linux-next list <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 15, 2013 at 9:08 AM, Jim Davis <jim.epost@gmail.com> wrote:
> Building with the attached random configuration file,
>
> In file included from drivers/pci/hotplug/cpqphp_core.c:45:0:
> drivers/pci/hotplug/cpqphp.h:204:2: error: redeclaration of enumerator
> ‘NUMBER_OF_ENTRIES’
>   NUMBER_OF_ENTRIES = offsetof(struct hrt, number_of_entries),
>   ^
> drivers/pci/hotplug/cpqphp.h:118:2: note: previous definition of
> ‘NUMBER_OF_ENTRIES’ was here
>   NUMBER_OF_ENTRIES = offsetof(struct smbios_entry_point, number_of_entries),
>   ^
>   CC      drivers/mtd/maps/physmap.o
> make[3]: *** [drivers/pci/hotplug/cpqphp_core.o] Error 1

I fixed this and repushed my "for-linus" branch, thanks.

Bjorn
