Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753233Ab3FZVtf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 17:49:35 -0400
Received: from terminus.zytor.com ([198.137.202.10]:40935 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752733Ab3FZVte (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 17:49:34 -0400
Message-ID: <51CB61DC.9030800@zytor.com>
Date: Wed, 26 Jun 2013 14:49:16 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130514 Thunderbird/17.0.6
MIME-Version: 1.0
To: Bjorn Helgaas <bhelgaas@google.com>
CC: Darren Hart <dvhart@linux.intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Peter P Waskiewicz Jr <peter.p.waskiewicz.jr@intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        danders@circuitco.com, vishal.l.verma@intel.com,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
Subject: Re: [PATCH 7/8] pci: Add CircuitCo VENDOR ID and MinnowBoard DEVICE
 ID
References: <cover.1372211451.git.dvhart@linux.intel.com> <83879b07cd4ce95f086420d1faa926c1692d63b4.1372211451.git.dvhart@linux.intel.com> <20130626163250.GA29299@google.com> <1372266904.8177.83.camel@envy.home> <CAErSpo6=1i76RRmJSUi+BpD9D0WrXaML4HkGLn0C=+6=ohB0uQ@mail.gmail.com> <51CB5D84.4080709@zytor.com> <CAErSpo6Dss9hj33QRP-Leob05WT-uN-MWUAZBfh+VDtUvCWNkA@mail.gmail.com>
In-Reply-To: <CAErSpo6Dss9hj33QRP-Leob05WT-uN-MWUAZBfh+VDtUvCWNkA@mail.gmail.com>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/26/2013 02:46 PM, Bjorn Helgaas wrote:
>>
>> Microsoft has a "best practices" document, which may end up becoming
>> basis for a future PCI-SIG document clarifying the standard:
>>
>> http://msdn.microsoft.com/en-us/library/windows/hardware/gg463287.aspx
> 
> Interesting, thanks for the link.  If I read that correctly, the
> MinnowBoard is basically a motherboard, and any board layout change or
> component value change will require a new Subsystem ID, which will in
> turn require a pch_gbe update.  That doesn't sound optimal, but maybe
> people don't actually interpret it that strictly.
> 

It could be interpreted that literally, yes.  This is part of why a
"subsystem" isn't necessarily forced to be a "board".

	-hpa


