Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754259Ab3ARRvC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2013 12:51:02 -0500
Received: from mail-ie0-f172.google.com ([209.85.223.172]:38210 "EHLO
	mail-ie0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751542Ab3ARRvA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2013 12:51:00 -0500
MIME-Version: 1.0
In-Reply-To: <CAErSpo6E0SrY8_JOU6pmrCt9opfKe_jJ6b0E0daNAbpX5KtFuQ@mail.gmail.com>
References: <1358525267-14268-1-git-send-email-jiang.liu@huawei.com>
	<1358525267-14268-8-git-send-email-jiang.liu@huawei.com>
	<CAErSpo6E0SrY8_JOU6pmrCt9opfKe_jJ6b0E0daNAbpX5KtFuQ@mail.gmail.com>
Date: Fri, 18 Jan 2013 09:50:59 -0800
X-Google-Sender-Auth: OER7XJHwz5MHVNQD1SMtlMKGN5o
Message-ID: <CAE9FiQU6K1M=rbnhPLsAkhK5dZw8CAoQzAi=YLjtz722jCix-w@mail.gmail.com>
Subject: Re: [RFC PATCH v5 7/8] PCI/PCIe: add "pci=nopciehp" to disable PCIe
 native hotplug
From: Yinghai Lu <yinghai@kernel.org>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Jiang Liu <liuj97@gmail.com>, "Rafael J . Wysocki" <rjw@sisk.pl>,
        Jiang Liu <jiang.liu@huawei.com>,
        Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
        Yijing Wang <wangyijing@huawei.com>, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Toshi Kani <toshi.kani@hp.com>, Myron Stowe <myron.stowe@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 18, 2013 at 9:35 AM, Bjorn Helgaas <bhelgaas@google.com> wrote:
> If you want "pci=nopciehp" as a way for users to deal with this
> problem by forcing the use of acpiphp, I object.  Windows manages to
> make these slots work without having users do anything special, so we
> should be able to do it, too.

Agreed.

We need to think that more.

I think that we should fix acpiphp, and should follow first come and
first serve for acpiphp and pciehp.

Yinghai
