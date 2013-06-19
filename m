Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755585Ab3FSFSo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 01:18:44 -0400
Received: from mail-qa0-f42.google.com ([209.85.216.42]:38619 "EHLO
	mail-qa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751089Ab3FSFSm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 01:18:42 -0400
MIME-Version: 1.0
In-Reply-To: <1880810.6jIKdDRiJm@vostro.rjw.lan>
References: <1371238081-32260-1-git-send-email-jiang.liu@huawei.com>
	<CAN_LGv1itN=ADE-3LNCoBJFXmpWZffhQb6NQuoBzvONkX3brug@mail.gmail.com>
	<CAN_LGv2Y6jebtNUQ1gJYfy8uG2pxtUjT1gqMPmL+6E7myELd3A@mail.gmail.com>
	<1880810.6jIKdDRiJm@vostro.rjw.lan>
Date: Wed, 19 Jun 2013 11:18:41 +0600
Message-ID: <CAN_LGv0DUH3o6=iCBcQDEOLQ3n=O=GR5BSQU5dLs306YeLVL7w@mail.gmail.com>
Subject: Re: [BUGFIX v2 0/4] fix bug 56531, 59501 and 59581
From: "Alexander E. Patrakov" <patrakov@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Jiang Liu <jiang.liu@huawei.com>, alexdeucher@gmail.com,
        Bjorn Helgaas <bhelgaas@google.com>, Yinghai Lu <yinghai@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Yijing Wang <wangyijing@huawei.com>, linux-acpi@vger.kernel.org,
        Jiang Liu <liuj97@gmail.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/6/19 Rafael J. Wysocki <rjw@sisk.pl>:
> OK, let's try to untangle this a bit.
>
> If you applyt patches [1/4] and [4/4] from the $subject series only, what
> does remain unfixed?

[not tested, can do so in 12 hours if needed]

I think there will be problems on undocking and/or on the second
docking, as described in comments #6 - #8 of
https://bugzilla.kernel.org/show_bug.cgi?id=59501

-- 
Alexander E. Patrakov
