Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757440Ab3APThs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 14:37:48 -0500
Received: from mail-bk0-f47.google.com ([209.85.214.47]:40254 "EHLO
	mail-bk0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754249Ab3APThm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 14:37:42 -0500
MIME-Version: 1.0
In-Reply-To: <2146678.ZYzAqhqxN1@vostro.rjw.lan>
References: <1357944049-29620-1-git-send-email-yinghai@kernel.org>
	<3905799.Wx2ixLIOL7@vostro.rjw.lan>
	<CAE9FiQUivk3d0L8UENMBgoqeaC3pGAg=mobjsRupHFhH0VGp7Q@mail.gmail.com>
	<2146678.ZYzAqhqxN1@vostro.rjw.lan>
Date: Wed, 16 Jan 2013 11:37:40 -0800
X-Google-Sender-Auth: 2oef2WIN0FwkN2diQQzRDUkeB2k
Message-ID: <CAE9FiQW8bNs3_nV1QbDMFwxCwEy2a-1x2vi=FQ9raCYpbmnu4Q@mail.gmail.com>
Subject: Re: [PATCH v8 14/22] ACPI: update ej_event interface to take acpi_device
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

On Wed, Jan 16, 2013 at 6:05 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
>
> acpi_power_transition() has to check if the device is power-manageable, since
> otherwise the power resources lists will not be initialized.  It should be
> fixed now.

yes, it works now with pm/linux-next.

will resend updated patchset after new acpi-scan get into pci/next.

Thanks

Yinghai
