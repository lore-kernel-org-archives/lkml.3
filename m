Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751595Ab3FYTaL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 15:30:11 -0400
Received: from mail-ob0-f180.google.com ([209.85.214.180]:37461 "EHLO
	mail-ob0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751242Ab3FYTaJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 15:30:09 -0400
MIME-Version: 1.0
In-Reply-To: <20130625185111.GL9294@intel.com>
References: <1372177330-28013-1-git-send-email-mika.westerberg@linux.intel.com>
	<1372177330-28013-6-git-send-email-mika.westerberg@linux.intel.com>
	<CAHp75Vd2Torku6zy2awLHRTed9mx94a6RAu+oHJYb+rVgZKBDQ@mail.gmail.com>
	<20130625183123.GJ9294@intel.com>
	<CAHp75Vc8BauuBJcfqBzu_+6nUwEC-uD3z_RF5gT-3YhV0fjTqw@mail.gmail.com>
	<20130625185111.GL9294@intel.com>
Date: Tue, 25 Jun 2013 22:30:08 +0300
Message-ID: <CAHp75VeX5ejA9ghaiAgEUVZ9ffpuRQc+VQCsJqXWWSW1Sm1cUQ@mail.gmail.com>
Subject: Re: [PATCH 5/6] PCI: acpiphp: look _RMV method a bit deeper in the hierarhcy
From: Andy Shevchenko <andy.shevchenko@gmail.com>
To: Mika Westerberg <mika.westerberg@linux.intel.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        Yinghai Lu <yinghai@kernel.org>, john.ronciak@intel.com,
        miles.j.penner@intel.com, bruce.w.allan@intel.com,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-pci@vger.kernel.org, x86@kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 25, 2013 at 9:51 PM, Mika Westerberg
<mika.westerberg@linux.intel.com> wrote:
> On Tue, Jun 25, 2013 at 09:31:52PM +0300, Andy Shevchenko wrote:

> I think it is better to remove the first value check from the
> pcihp_evaluate_rmv() and keep the check here.
>
> I'll fix that in the next revision as well.

In that case you may remove the removable assignment as well.

--
With Best Regards,
Andy Shevchenko
