Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754401AbaFKWU0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 18:20:26 -0400
Received: from mail-ve0-f182.google.com ([209.85.128.182]:59253 "EHLO
	mail-ve0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753048AbaFKWUY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 18:20:24 -0400
MIME-Version: 1.0
In-Reply-To: <539898C3.8090903@gmail.com>
References: <1397859600-11507-1-git-send-email-robherring2@gmail.com>
	<1397859600-11507-4-git-send-email-robherring2@gmail.com>
	<CAE9FiQVrwypK4u5yTCt-AxMuBnOn7jv=V3d4Zb3cd9JDNEUVPw@mail.gmail.com>
	<CAL_JsqKux+BTHeYo6XEzzQMAFJZHVjbURM973oHT=t698GbJbA@mail.gmail.com>
	<20140503220731.GA10927@kroah.com>
	<20140503221658.GA13403@kroah.com>
	<CA+8MBb+7f1bOnJjJWj1vxa0UNuQwz7OGRDR_QFTxOT=9cynabQ@mail.gmail.com>
	<CA+8MBbKE1E2uq9LefiDAV9hv2Z8OTkjx9mkXjE6_--F_emRC8A@mail.gmail.com>
	<CAL_JsqKvoO9acX==-LdD6boO=B3xr=ijra_G0uqRZGzACZZUJg@mail.gmail.com>
	<CA+8MBbLooWm9xys+gYa5uL1eVTH-qzaR+RaZgsrqV-8XkqGadQ@mail.gmail.com>
	<539898C3.8090903@gmail.com>
Date: Wed, 11 Jun 2014 15:20:23 -0700
Message-ID: <CA+8MBbKq8B8iECOYuanbM7wyJVFbW8TYkAw9JjiQ8s+H4V34CQ@mail.gmail.com>
Subject: Re: [PATCH v2 3/7] tty/serial: convert 8250 to generic earlycon
From: Tony Luck <tony.luck@gmail.com>
To: Rob Herring <robherring2@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Yinghai Lu <yinghai@kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-serial@vger.kernel.org" <linux-serial@vger.kernel.org>,
        Jiri Slaby <jslaby@suse.cz>, Catalin Marinas <catalin.marinas@arm.com>,
        Russell King <linux@arm.linux.org.uk>,
        Will Deacon <will.deacon@arm.com>, Arnd Bergmann <arnd@arndb.de>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 11, 2014 at 10:58 AM, Rob Herring <robherring2@gmail.com> wrote:
> I think I figured it out. The function
> serial8250_find_port_for_earlycon is failing to match 'uart' console to
> 'ttyS' console and transfer the options. It was also failing to create
> an option string when the baud rate is probed. Can you try out the
> below patch?

Rob,

That works.  Thanks for digging deeper into this.

Here's a tag for when you push that patch:

Reported-and-tested-by: Tony Luck <tony.luck@intel.com>

-Tony
