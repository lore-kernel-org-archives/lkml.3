Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755784Ab3KVRQO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Nov 2013 12:16:14 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:49736 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755526Ab3KVRQM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Nov 2013 12:16:12 -0500
Date: Fri, 22 Nov 2013 17:15:56 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: Jingoo Han <jg1.han@samsung.com>, "'Kyungmin Park'" <kmpark@infradead.org>,
        "'Henrique de Moraes Holschuh'" <ibm-acpi@hmh.eng.br>,
        linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kay@vrfy.org, "'Richard Purdie'" <rpurdie@rpsys.net>,
        ibm-acpi-devel@lists.sourceforge.net,
        platform-driver-x86@vger.kernel.org
Subject: Re: [PATCH] video: backlight: Remove backlight sysfs uevent
Message-ID: <20131122171556.GA15680@srcf.ucam.org>
References: <20131111235700.GA29987@july>
 <002901cedf3c$a7e77a00$f7b66e00$%han@samsung.com>
 <20131112005628.GA2914@khazad-dum.debian.net>
 <1384990859.20536.4.camel@x230>
 <20131121114332.GA23710@khazad-dum.debian.net>
 <20131121143326.GA19773@srcf.ucam.org>
 <20131122113601.GB27196@khazad-dum.debian.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131122113601.GB27196@khazad-dum.debian.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 22, 2013 at 09:36:01AM -0200, Henrique de Moraes Holschuh wrote:
> On Thu, 21 Nov 2013, Matthew Garrett wrote:
> > The uevent support was initially added to handle systems where pressing 
> > a hotkey generates an event (good) but the firmware automatically 
> > changes the brightness (bad). I have absolutely no idea why I added 
> > BACKLIGHT_UPDATE_SYSFS - BACKLIGHT_UPDATE_HOTKEY solves the problem I 
> > was trying to solve. I'm not aware of any userspace that relies on 
> > BACKLIGHT_UPDATE_SYSFS.
> 
> Well, either we have userspace that rely on the uevents, or we don't. 

We have userspace that relies on uevents of type 
BACKLIGHT_UPDATE_HOTKEY. I don't know that we have userspace that relies 
on uevents of type BACKLIGHT_UPDATE_SYSFS.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
