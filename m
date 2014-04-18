Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751523AbaDRKjE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2014 06:39:04 -0400
Received: from mail.skyhub.de ([78.46.96.112]:33634 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750857AbaDRKi6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2014 06:38:58 -0400
Date: Fri, 18 Apr 2014 12:38:54 +0200
From: Borislav Petkov <bp@alien8.de>
To: Dave Jones <davej@redhat.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "Zhang, Rui" <rui.zhang@intel.com>, "Lu, Aaron" <aaron.lu@intel.com>,
        lkml <linux-kernel@vger.kernel.org>, "x86@kernel.org" <x86@kernel.org>,
        Linux PCI <linux-pci@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Yinghai Lu <yinghai@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Stephane Eranian <eranian@google.com>,
        "Yan, Zheng Z" <zheng.z.yan@intel.com>, daniel.vetter@ffwll.ch
Subject: Re: Info: mapping multiple BARs. Your kernel is fine.
Message-ID: <20140418103854.GE4385@pd.tnic>
References: <20140416223122.GA2767@redhat.com>
 <20140416225600.GA23781@google.com>
 <20140417104533.GB8215@pd.tnic>
 <20140417182637.GA2098@google.com>
 <20140417195240.GA18876@redhat.com>
 <20140417200127.GH4321@pd.tnic>
 <20140417200352.GB18876@redhat.com>
 <20140417205355.GA22191@redhat.com>
 <20140417210101.GB27852@pd.tnic>
 <20140417213027.GA22412@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20140417213027.GA22412@redhat.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 17, 2014 at 05:30:27PM -0400, Dave Jones wrote:
> I think it's just implicated because that's the next thing that seems
> to init after the modeswitch. The config differences are small, just
> things like =m instead of =y or vice-versa.
>
> I'm about to head into a long weekend, so I'll get back to this on
> Monday, but for now I'm out of ideas.

This is for when you get back: :-)

Can you debug that hang a bit more, like enable some sensible options
under "Kernel Hacking" or somesuch, boot with initcall_debug, add
more printks at key places? If the machine would tell us why exactly
it hangs, we might have an idea, like corruption, transaction stall,
whatever...

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
