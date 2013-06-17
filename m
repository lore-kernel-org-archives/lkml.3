Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751601Ab3FQRHL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 13:07:11 -0400
Received: from mail-qe0-f46.google.com ([209.85.128.46]:47134 "EHLO
	mail-qe0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751563Ab3FQRHF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 13:07:05 -0400
MIME-Version: 1.0
In-Reply-To: <CAN_LGv0yXhQi82ck3mvTbwuZv2dhnYB7Xnk9P4=5XVoAaAAeZQ@mail.gmail.com>
References: <1371238081-32260-1-git-send-email-jiang.liu@huawei.com>
	<CAN_LGv1itN=ADE-3LNCoBJFXmpWZffhQb6NQuoBzvONkX3brug@mail.gmail.com>
	<51BDF705.5090904@gmail.com>
	<CAN_LGv0yXhQi82ck3mvTbwuZv2dhnYB7Xnk9P4=5XVoAaAAeZQ@mail.gmail.com>
Date: Mon, 17 Jun 2013 23:07:04 +0600
Message-ID: <CAN_LGv2GTgMJB8NL7iPnyk9bMvbDKE9i6HP0UV5d_9CfytJ0pg@mail.gmail.com>
Subject: Re: [BUGFIX v2 0/4] fix bug 56531, 59501 and 59581
From: "Alexander E. Patrakov" <patrakov@gmail.com>
To: Jiang Liu <liuj97@gmail.com>
Cc: Jiang Liu <jiang.liu@huawei.com>, alexdeucher@gmail.com,
        "Rafael J . Wysocki" <rjw@sisk.pl>,
        Bjorn Helgaas <bhelgaas@google.com>, Yinghai Lu <yinghai@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Yijing Wang <wangyijing@huawei.com>, linux-acpi@vger.kernel.org,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/6/17 Alexander E. Patrakov <patrakov@gmail.com>:
> I am not 100% sure that the static key backtrace is the same in all
> cases. However, I do remember that it does appear both in the
> non-hotplug and hotplug cases.
>
> I will retest this after work, i.e. in ~12 hours.

Tried again, failed to reproduce this warning. Sorry :(

--
Alexander E. Patrakov
