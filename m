Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757230Ab3AOVyf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 16:54:35 -0500
Received: from hydra.sisk.pl ([212.160.235.94]:41443 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756721Ab3AOVyd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 16:54:33 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>, Len Brown <lenb@kernel.org>,
        Taku Izumi <izumi.taku@jp.fujitsu.com>,
        Jiang Liu <jiang.liu@huawei.com>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
Subject: Re: [PATCH v8 08/22] PCI, acpiphp: Separate out hot-add support of pci host bridge
Date: Tue, 15 Jan 2013 23:00:25 +0100
Message-ID: <2763397.yFrgeYvBXr@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.8.0-rc3+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <CAE9FiQWCg9ZF8mXF-fMKUhOXF=EDeS07BWKvUSDxWUxikrQu4w@mail.gmail.com>
References: <1357944049-29620-1-git-send-email-yinghai@kernel.org> <CAE9FiQX6q-tbQuq_0mc0kBFC-bb0zKRDyg=aGLkrAeh5Y7FkYg@mail.gmail.com> <CAE9FiQWCg9ZF8mXF-fMKUhOXF=EDeS07BWKvUSDxWUxikrQu4w@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, January 15, 2013 07:54:22 AM Yinghai Lu wrote:
> On Mon, Jan 14, 2013 at 10:44 PM, Yinghai Lu <yinghai@kernel.org> wrote:
> > On Sat, Jan 12, 2013 at 3:18 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> >>> @@ -673,3 +673,223 @@ int __init acpi_pci_root_init(void)
> >>>
> >>>       return 0;
> >>>  }
> >>> +
> >>> +/*
> >>> + * Separated from drivers/pci/hotplug/acpiphp_glue.c
> >>> + *   only support root bridge
> >>> + */
> >>
> >> This comment will be useless after applying the patch.
> >>
> >>> +
> >>> +static LIST_HEAD(acpi_root_bridge_list);
> >>> +struct acpi_root_bridge {
> >>> +     struct list_head list;
> >>> +     acpi_handle handle;
> >>> +     u32 flags;
> >>> +};
> >>
> >> We have struct acpi_pci_root already.  Why do we need this in addition?
> >
> > will address that in following patch.
> 
> please check if you are ok with merging attached 5 patches in to one
> patches instead.

Do I understand correctly that you're asking whether to merge the attached
patches together, so as to obtain one combined patch?

If so, yes, I'd like that to be done.

Thanks,
Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
