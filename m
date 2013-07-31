Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760665Ab3GaSrb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jul 2013 14:47:31 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:42299 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755226Ab3GaSr3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jul 2013 14:47:29 -0400
Date: Wed, 31 Jul 2013 19:47:24 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Felipe Contreras <felipe.contreras@gmail.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Aaron Lu <aaron.lwe@gmail.com>,
        linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
        Len Brown <lenb@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [REGRESSION/PATCH] acpi: blacklist win8 OSI for ASUS Zenbok
 Prime UX31A
Message-ID: <20130731184724.GA30896@srcf.ucam.org>
References: <3453253.oZLO1ChPbL@vostro.rjw.lan>
 <CAMP44s02V_FO1BPJZqo6MB9RMknXYdV7AXDqbJzYHpgK1GUuJw@mail.gmail.com>
 <37178266.QXgbv9rq0i@vostro.rjw.lan>
 <CAMP44s2LqiEGtS72FuTjsHUa1MH2kfaYHmcpNKMmAm2LnbFCCQ@mail.gmail.com>
 <20130731051421.GA15766@srcf.ucam.org>
 <CAMP44s2B=nQLnZm7gyYAJZgt_x3KszRZLUC=fom0t9=Eze+smA@mail.gmail.com>
 <20130731140010.GA24560@srcf.ucam.org>
 <CAMP44s1cLou9TMfLS+FHwPM_b3bG5HN1-hzgvhz0fVRCZ8XqWw@mail.gmail.com>
 <20130731175232.GA29987@srcf.ucam.org>
 <CAMP44s1c5pmiC2fvmRi9vFrJXb2zYUT_F=paM2LR_V+7THnFVg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMP44s1c5pmiC2fvmRi9vFrJXb2zYUT_F=paM2LR_V+7THnFVg@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 31, 2013 at 01:07:57PM -0500, Felipe Contreras wrote:
> If we can make the software behave consistently for 99% of the
> machines out there instead of only 90%, that's better.

If we can't make an interface 100% consistent, we shouldn't pretend that 
the interface is 100% consistent. We can't, and so we don't. Setting a 
backlight value of 0 may turn the screen off, and userspace needs to 
deal with that.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
