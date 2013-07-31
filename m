Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759670Ab3GaOAR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jul 2013 10:00:17 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:38135 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752686Ab3GaOAP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jul 2013 10:00:15 -0400
Date: Wed, 31 Jul 2013 15:00:10 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Felipe Contreras <felipe.contreras@gmail.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Aaron Lu <aaron.lwe@gmail.com>,
        linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
        Len Brown <lenb@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [REGRESSION/PATCH] acpi: blacklist win8 OSI for ASUS Zenbok
 Prime UX31A
Message-ID: <20130731140010.GA24560@srcf.ucam.org>
References: <1375125658-1223-1-git-send-email-felipe.contreras@gmail.com>
 <3453253.oZLO1ChPbL@vostro.rjw.lan>
 <CAMP44s02V_FO1BPJZqo6MB9RMknXYdV7AXDqbJzYHpgK1GUuJw@mail.gmail.com>
 <37178266.QXgbv9rq0i@vostro.rjw.lan>
 <CAMP44s2LqiEGtS72FuTjsHUa1MH2kfaYHmcpNKMmAm2LnbFCCQ@mail.gmail.com>
 <20130731051421.GA15766@srcf.ucam.org>
 <CAMP44s2B=nQLnZm7gyYAJZgt_x3KszRZLUC=fom0t9=Eze+smA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMP44s2B=nQLnZm7gyYAJZgt_x3KszRZLUC=fom0t9=Eze+smA@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 31, 2013 at 06:32:47AM -0500, Felipe Contreras wrote:
> On Wed, Jul 31, 2013 at 12:14 AM, Matthew Garrett <mjg59@srcf.ucam.org> wrote:
> > There's no mechanism for an OS to know whether or not a firmware
> > implementation will actually turn the backlight off at 0, so there's no
> > way the OS can define the lowest backlight state as anything other than
> > "May or may not turn the screen off".
> 
> Yes there is; quirks.

We aren't going to maintain a quirk list in order to support a guarantee 
that was never made. "0" as a backlight level has potentially meant 
"screen off" since the interface was first introduced.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
