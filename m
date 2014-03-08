Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751890AbaCHOok (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Mar 2014 09:44:40 -0500
Received: from cpsmtpb-ews04.kpnxchange.com ([213.75.39.7]:60685 "EHLO
	cpsmtpb-ews04.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751460AbaCHOoj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Mar 2014 09:44:39 -0500
Message-ID: <1394289877.31006.2.camel@x41>
Subject: Re: [Intel-gfx] agp/intel: can't ioremap flush page - no chipset
 flushing
From: Paul Bolle <pebolle@tiscali.nl>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Steven Newbury <steve@snewbury.org.uk>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        David Airlie <airlied@linux.ie>,
        intel-gfx <intel-gfx@lists.freedesktop.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Yinghai Lu <yinghai@kernel.org>
Date: Sat, 08 Mar 2014 15:44:37 +0100
In-Reply-To: <CAErSpo7Np8oju1ENQA5EgEpN4=Vv7f3s4E823ecbyp6FCWPL_Q@mail.gmail.com>
References: <1391886379.2669.11.camel@x41>
	 <CAKMK7uE6Gaq-ghgWJ+6Qyn7hrGzAMOHyGT9KQQJ+ij7omPV2Ew@mail.gmail.com>
	 <1391890927.1882.5.camel@x41>
	 <CAKMK7uFx2kksGgnuy9e0xiQRKpt=_+44O1V4wbX5yNBocvjBkg@mail.gmail.com>
	 <1391951759.6036.7.camel@artifact> <1391952344.25424.4.camel@x220>
	 <CAErSpo6uj_Kuk0_F97nRsnM1Pss4C7=HeEaVu6D-NwFFK=1cvA@mail.gmail.com>
	 <1394185698.5608.5.camel@x41>
	 <CAErSpo4jiq38P3TNuGLGS--nbV9NtUAmiuK=cwWyFAneY-=eOA@mail.gmail.com>
	 <1394212609.1987.6.camel@x41> <20140307204021.GA9822@google.com>
	 <CAErSpo7Np8oju1ENQA5EgEpN4=Vv7f3s4E823ecbyp6FCWPL_Q@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-2.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 08 Mar 2014 14:44:37.0461 (UTC) FILETIME=[EDD81050:01CF3ADC]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bjorn Helgaas schreef op za 08-03-2014 om 07:12 [-0700]:
> I assume you have CONFIG_PHYS_ADDR_T_64BIT=n (which is perfectly
> legal); let me know if otherwise.

$ grep CONFIG_PHYS_ADDR_T_64BIT /boot/config-3.14.0-0.rc5.1.local2.fc20.i686 
# CONFIG_PHYS_ADDR_T_64BIT is not set

So, yes, CONFIG_PHYS_ADDR_T_64BIT=n here.


Paul Bolle

