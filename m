Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758474Ab3FMRe1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jun 2013 13:34:27 -0400
Received: from mail-qa0-f47.google.com ([209.85.216.47]:47049 "EHLO
	mail-qa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752653Ab3FMReZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jun 2013 13:34:25 -0400
MIME-Version: 1.0
In-Reply-To: <1371141152-9468-10-git-send-email-jiang.liu@huawei.com>
References: <1371141152-9468-1-git-send-email-jiang.liu@huawei.com>
	<1371141152-9468-10-git-send-email-jiang.liu@huawei.com>
Date: Thu, 13 Jun 2013 23:34:24 +0600
Message-ID: <CAN_LGv0H82nGmmz0wtLp6bUebyo0o_O9ye9n-1YXqfohv_qpOQ@mail.gmail.com>
Subject: Re: [BUGFIX 9/9] ACPI: use new helper functions to simpilify code
From: "Alexander E. Patrakov" <patrakov@gmail.com>
To: Jiang Liu <jiang.liu@huawei.com>
Cc: "Rafael J . Wysocki" <rjw@sisk.pl>, Bjorn Helgaas <bhelgaas@google.com>,
        Yinghai Lu <yinghai@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Yijing Wang <wangyijing@huawei.com>, Jiang Liu <liuj97@gmail.com>,
        linux-pci@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/6/13 Jiang Liu <jiang.liu@huawei.com>:
> Use new helper functions to simpilify ACPI dock, acpiphp code.

Not tested yet, just looking at the code

> -       /*
> -        * TBD: _EJD support.
> -        */

You have removed this comment. Did it become invalid since it has been written?

-- 
Alexander E. Patrakov
