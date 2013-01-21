Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752642Ab3AUCm7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jan 2013 21:42:59 -0500
Received: from mail-ie0-f171.google.com ([209.85.223.171]:54315 "EHLO
	mail-ie0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752534Ab3AUCm4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jan 2013 21:42:56 -0500
MIME-Version: 1.0
In-Reply-To: <14158003.3rfOuOmdG2@vostro.rjw.lan>
References: <1358495602-22867-1-git-send-email-yinghai@kernel.org>
	<1358495602-22867-10-git-send-email-yinghai@kernel.org>
	<14158003.3rfOuOmdG2@vostro.rjw.lan>
Date: Sun, 20 Jan 2013 18:42:55 -0800
X-Google-Sender-Auth: EI8czWxlK846Even2kukjPPdpCk
Message-ID: <CAE9FiQUac48U0o4dr3ONdqeBvGsgHGRtOemTh+4FtKcGVbCG4w@mail.gmail.com>
Subject: Re: [PATCH v9 09/11] PCI, acpiphp: Don't bailout even no slots found yet.
From: Yinghai Lu <yinghai@kernel.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Bjorn Helgaas <bhelgaas@google.com>, Len Brown <lenb@kernel.org>,
        Taku Izumi <izumi.taku@jp.fujitsu.com>,
        Jiang Liu <jiang.liu@huawei.com>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>
> If that's the case:
>
> Acked-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
>
> but please say something like this in the changelog:
>
> "The result returned by acpiphp_get_num_slots() is meaningless, because
>  the bridge the slots are under may be added after this function has been
>  called, so drop acpiphp_get_num_slots() and the code using it."

yes, I add you inputs into change log.

Thanks a lot
