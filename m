Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753331AbaKLSa6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 13:30:58 -0500
Received: from mail-yk0-f172.google.com ([209.85.160.172]:42234 "EHLO
	mail-yk0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753056AbaKLSa5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 13:30:57 -0500
MIME-Version: 1.0
In-Reply-To: <CAErSpo7Z5x=U3vSnxrFpwYUDrUrnrrBCe1F9_GQNYqWWQFWNpQ@mail.gmail.com>
References: <1415847123-15558-1-git-send-email-michael.jamet@intel.com>
	<CAErSpo7Z5x=U3vSnxrFpwYUDrUrnrrBCe1F9_GQNYqWWQFWNpQ@mail.gmail.com>
Date: Wed, 12 Nov 2014 20:30:56 +0200
Message-ID: <CAHp75VcZ0XjcFxjrSgr5-XnWZZa-eZfPH_Fa1Hzb=f+qtE3z9w@mail.gmail.com>
Subject: Re: [PATCH] pci: support Thunderbolt requirements for I/O resources.
From: Andy Shevchenko <andy.shevchenko@gmail.com>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Michael Jamet <michael.jamet@intel.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        amir.jer.levy@intel.com, dan.alloun@intel.com,
        Rafael Wysocki <rjw@rjwysocki.net>,
        Andreas Noever <andreas.noever@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 12, 2014 at 7:29 PM, Bjorn Helgaas <bhelgaas@google.com> wrote:

[]

>> To prevent this, we detect a chain contains a Thunderbolt
>> device by checking the Thunderbolt PCI device id.
>
> I'm really not happy about checking a list of device IDs to identify
> Thunderbolt devices.  Surely there's a better way, because a list like
> this has to be updated regularly.

I recently proposed internally to use quirks (pci_fixup_early) for
that, but apparently Michael didn't have time to answer. It might be
he can just comment here since the patch already public.

-- 
With Best Regards,
Andy Shevchenko
