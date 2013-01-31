Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755044Ab3AaQAB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2013 11:00:01 -0500
Received: from mail-ia0-f173.google.com ([209.85.210.173]:47285 "EHLO
	mail-ia0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751342Ab3AaP76 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2013 10:59:58 -0500
MIME-Version: 1.0
In-Reply-To: <510A8F9C.5090306@gmail.com>
References: <1359562210-26536-1-git-send-email-jiang.liu@huawei.com>
	<1359562210-26536-2-git-send-email-jiang.liu@huawei.com>
	<CAE9FiQU2LvEjTpbjs+LUb=vU7XDC_76OEo5irR_Bn_DjvfgQ0w@mail.gmail.com>
	<510A8F9C.5090306@gmail.com>
Date: Thu, 31 Jan 2013 07:59:57 -0800
X-Google-Sender-Auth: 3hEfAt7kpdU6--uW1YNxbQYJX0o
Message-ID: <CAE9FiQXBOj7wCJkXPoBDPiVNH7K0iQPExfrWhAuzwVcyrN+ZZQ@mail.gmail.com>
Subject: Re: [PATCH 2/2] acpiphp: remove dead code for PCI host bridge hotplug
From: Yinghai Lu <yinghai@kernel.org>
To: Jiang Liu <liuj97@gmail.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>, "Rafael J . Wysocki" <rjw@sisk.pl>,
        Jiang Liu <jiang.liu@huawei.com>, Yijing Wang <wangyijing@huawei.com>,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 31, 2013 at 7:37 AM, Jiang Liu <liuj97@gmail.com> wrote:
>
> So I think the code in handle_hotplug_event_bridge() to handle P2P hot-addition
> is dead. Yijing has helped to test the code by faking ACPI CUSTOM_METHOD, and it
> does work as expected.

ok, then.

It would be better if you can append some print out from Yijing's test
in the changelog.

Thanks

Yinghai
