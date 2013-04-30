Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933672Ab3D3VMI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Apr 2013 17:12:08 -0400
Received: from cantor2.suse.de ([195.135.220.15]:59925 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933058Ab3D3VMF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Apr 2013 17:12:05 -0400
Date: Tue, 30 Apr 2013 23:12:04 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jonathan Corbet <corbet@lwn.net>, Dave Jones <davej@redhat.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] dummy-irq: require the user to specify an IRQ number
In-Reply-To: <20130430205016.GB26374@kroah.com>
Message-ID: <alpine.LNX.2.00.1304302311260.20139@pobox.suse.cz>
References: <20130429211605.GA4102@redhat.com> <alpine.LNX.2.00.1304300651080.20139@pobox.suse.cz> <20130430072817.61d3ca9f@lwn.net> <alpine.LNX.2.00.1304302240390.20139@pobox.suse.cz> <20130430205016.GB26374@kroah.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 30 Apr 2013, Greg Kroah-Hartman wrote:

> > From: Jonathan Corbet <corbet@lwn.net>
> > Subject: [PATCH] dummy-irq: require the user to specify an IRQ number
> > 
> > Make sure that we let the user know that without specifying IRQ#, 
> > dummy-irq driver is useless.
> > 
> > Reported-by: Dave Jones <davej@redhat.com>
> > Signed-off-by: Jonathan Corbet <corbet@lwn.net>
> > Signed-off-by: Jiri Kosina <jkosina@suse.cz>
> 
> Nice, I'll queue this up after 3.10-rc1 is out, thanks.

Thanks Greg.

Do you want me to resend this after rc1, or is it somewhere in your 
post-rc1 queue already?

-- 
Jiri Kosina
SUSE Labs
