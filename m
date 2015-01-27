Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757828AbbA0X1W (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 18:27:22 -0500
Received: from mail-wg0-f50.google.com ([74.125.82.50]:46143 "EHLO
	mail-wg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754373AbbA0X1V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 18:27:21 -0500
MIME-Version: 1.0
In-Reply-To: <CAErSpo64i1UhAoX5_MqVRerdpqq6gvmXg4DOqe3ndejPh5oGgg@mail.gmail.com>
References: <20150123203145.GA6691@google.com>
	<CA+8MBbKnT=mE3kev8BRPq0GeTgHx8WVa6o54tJuBX_XXLpHdYQ@mail.gmail.com>
	<CAErSpo7y1wWStjcEOH9xTiM-As8+QeMynZ5ENrL9v3X2PvQCcw@mail.gmail.com>
	<CA+8MBb+bWiX2eayjBQHsvCjTp3t8H9=AviF9AkV6CC--cC_fYQ@mail.gmail.com>
	<20150126235334.GA11624@google.com>
	<CAE9FiQUd8XgEhBKqFEyDLMTySw=jngtLN=zZeQcfW6=vC_b4mA@mail.gmail.com>
	<CAErSpo64i1UhAoX5_MqVRerdpqq6gvmXg4DOqe3ndejPh5oGgg@mail.gmail.com>
Date: Tue, 27 Jan 2015 15:27:19 -0800
Message-ID: <CA+8MBbJHsh5U7FJMVDGY9tpidKCcgQS2xyFxdh1CyEfENGMbNw@mail.gmail.com>
Subject: Re: [GIT PULL] PCI fixes for v3.19
From: Tony Luck <tony.luck@gmail.com>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Yinghai Lu <yinghai@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Lucas Stach <l.stach@pengutronix.de>,
        Richard Zhu <Richard.Zhu@freescale.com>,
        Marek Kordik <kordikmarek@gmail.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Andreas Hartmann <andihartmann@freenet.de>,
        Alexey Voronkov <zermond@gmail.com>, David Airlie <airlied@linux.ie>,
        Alex Deucher <alexander.deucher@amd.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 27, 2015 at 6:03 AM, Bjorn Helgaas <bhelgaas@google.com> wrote:
> Just to make sure we're planning the same thing, I expect that we will
> fix or workaround both issues so it works just as well as v3.18 by the
> time v3.19 is released.  This is a system in the field, and we should
> be able to figure out how to deal with the broken firmware.  Asking
> users to upgrade their firmware is not the solution I'm looking for.

Good to hear.  BIOS in this machine is dated May, 2010 ... I doubt I could
find anyone who still remembers how to build a BIOS for it, let alone has
any motivation to actually do it.

-Tony
