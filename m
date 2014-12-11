Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965144AbaLKQhf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2014 11:37:35 -0500
Received: from mail-qc0-f170.google.com ([209.85.216.170]:41144 "EHLO
	mail-qc0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934351AbaLKQhd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2014 11:37:33 -0500
MIME-Version: 1.0
In-Reply-To: <CAE9FiQW95VoJ35+KXOfV8eqFjSnhgkAqUmFWOKyKMwOAR_x7Kg@mail.gmail.com>
References: <1414387308-27148-5-git-send-email-jiang.liu@linux.intel.com>
 <tip-e22ce93870deae0e9a54e1539f0088538f187780@git.kernel.org>
 <CAE9FiQWaL1Qu1eP-fQV784ucy+r-65AZ95VyiUrefn0dNtfLDw@mail.gmail.com>
 <alpine.DEB.2.11.1412101820510.13233@nanos> <CAE9FiQW95VoJ35+KXOfV8eqFjSnhgkAqUmFWOKyKMwOAR_x7Kg@mail.gmail.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Thu, 11 Dec 2014 09:37:12 -0700
Message-ID: <CAErSpo6D=-jyeuLowr+8tU0ncGdGUp7XRR7Ocofk8dQcx5X9Mw@mail.gmail.com>
Subject: Re: [tip:x86/apic] x86, PCI, ACPI: Kill private function
 resource_to_addr() in arch/x86/pci/acpi.c
To: Yinghai Lu <yinghai@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Jiang Liu <jiang.liu@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Borislav Petkov <bp@alien8.de>, Randy Dunlap <rdunlap@infradead.org>,
        Ingo Molnar <mingo@kernel.org>, Joerg Roedel <joro@8bytes.org>,
        Tony Luck <tony.luck@intel.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "linux-tip-commits@vger.kernel.org" 
	<linux-tip-commits@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 10, 2014 at 5:31 PM, Yinghai Lu <yinghai@kernel.org> wrote:
> On Wed, Dec 10, 2014 at 12:15 PM, Thomas Gleixner <tglx@linutronix.de> wrote:
>> On Tue, 9 Dec 2014, Yinghai Lu wrote:
>>
>> Can you please
>> ...
>> 2) Send patches inline. It's a pain to review and reply and I can't
>>    use my normal tooling.

I agree, it is noticeably more hassle for me to deal with patches sent
as attachments.  I can do it, but I tend to avoid it because it's a
nuisance.

> I can not, as gmail does not allow that.

I agree, gmail is a pain in the neck in this regard.  I personally use
mutt with imap to my gmail account to send patches and to review and
apply patches.  It isn't perfect, and it is a bit of a hassle, but it
can be done.

Bjorn
