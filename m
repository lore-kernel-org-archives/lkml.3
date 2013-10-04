Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755421Ab3JDRj4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Oct 2013 13:39:56 -0400
Received: from terminus.zytor.com ([198.137.202.10]:58998 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754326Ab3JDRjy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Oct 2013 13:39:54 -0400
Message-ID: <524EFD49.6030606@zytor.com>
Date: Fri, 04 Oct 2013 10:39:21 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Bjorn Helgaas <bhelgaas@google.com>
CC: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "x86@kernel.org" <x86@kernel.org>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        Lior Amsalem <alior@marvell.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        daniel.price@gmail.com, Thierry Reding <thierry.reding@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jason Cooper <jason@lakedaemon.net>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: Re: [PATCH] x86: fix PCI_MSI build on !SMP
References: <20130930171849.GW3106@phenom.dumpdata.com> <1380794354-9079-1-git-send-email-thomas.petazzoni@free-electrons.com> <CAErSpo4a+LeJ=bok+idNHEFw96ySxYA2JywRwTq0VDMtL0d=5A@mail.gmail.com>
In-Reply-To: <CAErSpo4a+LeJ=bok+idNHEFw96ySxYA2JywRwTq0VDMtL0d=5A@mail.gmail.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/04/2013 10:36 AM, Bjorn Helgaas wrote:
> 
> FWIW,
> 
> Acked-by: Bjorn Helgaas <bhelgaas@google.com>
> 
> x86 maintainers, I assume you'll pick this up.  Let me know if you
> want me to do it.
> 

I'll grab it.

	-hpa


