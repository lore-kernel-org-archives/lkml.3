Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751371Ab3DMEDu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Apr 2013 00:03:50 -0400
Received: from mail-pb0-f44.google.com ([209.85.160.44]:57981 "EHLO
	mail-pb0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750755Ab3DMEDs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Apr 2013 00:03:48 -0400
Message-ID: <5168D91B.7080606@gmail.com>
Date: Sat, 13 Apr 2013 12:03:39 +0800
From: Jiang Liu <liuj97@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130308 Thunderbird/17.0.4
MIME-Version: 1.0
To: Bjorn Helgaas <bhelgaas@google.com>
CC: "Rafael J . Wysocki" <rjw@sisk.pl>, Jiang Liu <jiang.liu@huawei.com>,
        Yinghai Lu <yinghai@kernel.org>, Yijing Wang <wangyijing@huawei.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Toshi Kani <toshi.kani@hp.com>, Myron Stowe <myron.stowe@redhat.com>
Subject: Re: [PATCH v9 00/16] Get rid of the ACPI PCI subdriver mechanism
References: <1365781470-32379-1-git-send-email-jiang.liu@huawei.com> <CAErSpo6uVRvuaOusRi=d8g52gwOR1RzEaAep0OxSwjgZ1qk6BQ@mail.gmail.com>
In-Reply-To: <CAErSpo6uVRvuaOusRi=d8g52gwOR1RzEaAep0OxSwjgZ1qk6BQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/13/2013 06:17 AM, Bjorn Helgaas wrote:
> On Fri, Apr 12, 2013 at 9:44 AM, Jiang Liu <liuj97@gmail.com> wrote:
> 
> I applied these to my pci/jiang-subdrivers branch with minor tweaks.
> The most significant is that I folded in the acpiphp.disable option to
> the patch that makes the driver builtin-only.  That way there's no
> window between removing the "edit modules.conf" workaround and adding
> the kernel parameter.
> 
> Take a look and make sure it's what you want:
> http://git.kernel.org/cgit/linux/kernel/git/helgaas/pci.git/log/?h=pci/jiang-subdrivers
> 
> Bjorn
Hi Bjorn,
	Thanks for your support, it seems OK to me.
	Regards!
	Gerry

