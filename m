Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964904AbaLKHmp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2014 02:42:45 -0500
Received: from mail-wi0-f171.google.com ([209.85.212.171]:40998 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754188AbaLKHmo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2014 02:42:44 -0500
Date: Thu, 11 Dec 2014 08:42:37 +0100
From: Richard Cochran <richardcochran@gmail.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Borislav Petkov <bp@alien8.de>, Thomas Gleixner <tglx@linutronix.de>,
        Jiang Liu <jiang.liu@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Bjorn Helgaas <bhelgaas@google.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Randy Dunlap <rdunlap@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        Joerg Roedel <joro@8bytes.org>, Tony Luck <tony.luck@intel.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "linux-tip-commits@vger.kernel.org" 
	<linux-tip-commits@vger.kernel.org>
Subject: Re: [tip:x86/apic] x86, PCI, ACPI: Kill private function
 resource_to_addr() in arch/x86/pci/acpi.c
Message-ID: <20141211074237.GA4231@localhost.localdomain>
References: <1414387308-27148-5-git-send-email-jiang.liu@linux.intel.com>
 <tip-e22ce93870deae0e9a54e1539f0088538f187780@git.kernel.org>
 <CAE9FiQWaL1Qu1eP-fQV784ucy+r-65AZ95VyiUrefn0dNtfLDw@mail.gmail.com>
 <alpine.DEB.2.11.1412101820510.13233@nanos>
 <CAE9FiQW95VoJ35+KXOfV8eqFjSnhgkAqUmFWOKyKMwOAR_x7Kg@mail.gmail.com>
 <20141211003507.GI17053@pd.tnic>
 <CAE9FiQXBJABuH08GyE7qC2yRpU-mm8KVU5DA16uyq7Et4DctsQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAE9FiQXBJABuH08GyE7qC2yRpU-mm8KVU5DA16uyq7Et4DctsQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 10, 2014 at 05:57:12PM -0800, Yinghai Lu wrote:
> Tried with mutt or thunderbird etc, all kept on downloading ....

Mutt with gmail via imap works just fine for me.

  set folder="imaps://imap.gmail.com:993"
  set imap_user="luser@gmail.com"
  set imap_pass="SuperSecret"

You don't have to set imap_pass if you prefer an interactive prompt.

Thanks,
Richard
