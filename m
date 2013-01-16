Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757504Ab3APVmN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 16:42:13 -0500
Received: from hydra.sisk.pl ([212.160.235.94]:42117 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757478Ab3APVmK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 16:42:10 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>, Len Brown <lenb@kernel.org>,
        Taku Izumi <izumi.taku@jp.fujitsu.com>,
        Jiang Liu <jiang.liu@huawei.com>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
Subject: Re: [PATCH v8 14/22] ACPI: update ej_event interface to take acpi_device
Date: Wed, 16 Jan 2013 22:48:03 +0100
Message-ID: <2332793.JffINKpypu@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.8.0-rc3+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <CAE9FiQW8bNs3_nV1QbDMFwxCwEy2a-1x2vi=FQ9raCYpbmnu4Q@mail.gmail.com>
References: <1357944049-29620-1-git-send-email-yinghai@kernel.org> <2146678.ZYzAqhqxN1@vostro.rjw.lan> <CAE9FiQW8bNs3_nV1QbDMFwxCwEy2a-1x2vi=FQ9raCYpbmnu4Q@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, January 16, 2013 11:37:40 AM Yinghai Lu wrote:
> On Wed, Jan 16, 2013 at 6:05 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> >
> > acpi_power_transition() has to check if the device is power-manageable, since
> > otherwise the power resources lists will not be initialized.  It should be
> > fixed now.
> 
> yes, it works now with pm/linux-next.

Cool, thanks for testing!

> will resend updated patchset after new acpi-scan get into pci/next.

I'll put the new patches into acpi-scan tomorrow.  After that it's up to Bjorn
to decide when to pull them.

Thanks,
Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
