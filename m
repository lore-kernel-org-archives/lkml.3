Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933459AbaLKAfO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 19:35:14 -0500
Received: from mail.skyhub.de ([78.46.96.112]:54638 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932621AbaLKAfL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 19:35:11 -0500
Date: Thu, 11 Dec 2014 01:35:07 +0100
From: Borislav Petkov <bp@alien8.de>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>,
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
Message-ID: <20141211003507.GI17053@pd.tnic>
References: <1414387308-27148-5-git-send-email-jiang.liu@linux.intel.com>
 <tip-e22ce93870deae0e9a54e1539f0088538f187780@git.kernel.org>
 <CAE9FiQWaL1Qu1eP-fQV784ucy+r-65AZ95VyiUrefn0dNtfLDw@mail.gmail.com>
 <alpine.DEB.2.11.1412101820510.13233@nanos>
 <CAE9FiQW95VoJ35+KXOfV8eqFjSnhgkAqUmFWOKyKMwOAR_x7Kg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAE9FiQW95VoJ35+KXOfV8eqFjSnhgkAqUmFWOKyKMwOAR_x7Kg@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 10, 2014 at 04:31:22PM -0800, Yinghai Lu wrote:
> > 2) Send patches inline. It's a pain to review and reply and I can't
> >    use my normal tooling.
> 
> I can not, as gmail does not allow that.

Lemme guess, this is some kind of a joke you're making, right?

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
