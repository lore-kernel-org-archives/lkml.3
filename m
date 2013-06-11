Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752406Ab3FKIUS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jun 2013 04:20:18 -0400
Received: from cantor2.suse.de ([195.135.220.15]:35503 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751700Ab3FKIUQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jun 2013 04:20:16 -0400
From: Oliver Neukum <oneukum@suse.de>
To: "Morales, Alejandra" <alejandra.morales@tum.de>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Questions about Runtime Power Management
Date: Tue, 11 Jun 2013 10:21:37 +0200
Message-ID: <6962070.dqPY4e5mso@linux-5eaq.site>
Organization: SUSE
User-Agent: KMail/4.10.3 (Linux/3.7.10-1.11-desktop; KDE/4.10.4; x86_64; ; )
In-Reply-To: <9E3F9C2076C45D4783F09B90D5BE77CE171D3B@BADWLRZ-SWMBX14.ads.mwn.de>
References: <9E3F9C2076C45D4783F09B90D5BE77CE16B4E6@BADWLRZ-SWMBX13.ads.mwn.de> <8961845.QtBW1c5NsD@linux-5eaq.site> <9E3F9C2076C45D4783F09B90D5BE77CE171D3B@BADWLRZ-SWMBX14.ads.mwn.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 11 June 2013 07:53:10 Morales, Alejandra wrote:
> 2013/6/10 Oliver Neukum <oneukum@suse.de>

> > You need to furthermore realise that there are forms of runtime PM independent
> > of the generic kernel based runtime PM (hdparm, USB LPM, ...)
> 
> 
> Thanks Oliver, that was helpful. I will try now to do my testing using USB devices as it will likely be easier.

Note:

1. for most usb devices the default for runtime PM is off (powertop will help)
2. all a device's interface drivers must support it (look at the kernel source for .supports_autosuspend = 1)
3. If you want the HCD to go to D3 you need ACPI 5.0

	HTH
		Oliver

