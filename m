Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750874AbaDQVBX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 17:01:23 -0400
Received: from mail.skyhub.de ([78.46.96.112]:54608 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753011AbaDQVBF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 17:01:05 -0400
Date: Thu, 17 Apr 2014 23:01:01 +0200
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
Message-ID: <20140417210101.GB27852@pd.tnic>
References: <20140416190404.GA7070@pd.tnic>
 <20140416203138.GA17661@google.com>
 <20140416223122.GA2767@redhat.com>
 <20140416225600.GA23781@google.com>
 <20140417104533.GB8215@pd.tnic>
 <20140417182637.GA2098@google.com>
 <20140417195240.GA18876@redhat.com>
 <20140417200127.GH4321@pd.tnic>
 <20140417200352.GB18876@redhat.com>
 <20140417205355.GA22191@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20140417205355.GA22191@redhat.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 17, 2014 at 04:53:55PM -0400, Dave Jones wrote:
> ok, with your config I get back to a console after the modesetting
> switch, but then it hangs in USB init.

Maybe because of our machines are not that similar there? Can you take
my config but paste the usb part of yours and see whether it boots fine
then? It could be yours and mine have different USB hw...

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
