Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755436Ab3KTXlg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Nov 2013 18:41:36 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:50909 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755336Ab3KTXld (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Nov 2013 18:41:33 -0500
Message-ID: <1384990859.20536.4.camel@x230>
Subject: Re: [PATCH] video: backlight: Remove backlight sysfs uevent
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: Jingoo Han <jg1.han@samsung.com>, "'Kyungmin Park'" <kmpark@infradead.org>,
        "'Henrique de Moraes Holschuh'" <ibm-acpi@hmh.eng.br>,
        linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kay@vrfy.org, "'Richard Purdie'" <rpurdie@rpsys.net>,
        ibm-acpi-devel@lists.sourceforge.net,
        platform-driver-x86@vger.kernel.org
Date: Wed, 20 Nov 2013 18:40:59 -0500
In-Reply-To: <20131112005628.GA2914@khazad-dum.debian.net>
References: <20131111235700.GA29987@july>
	 <002901cedf3c$a7e77a00$f7b66e00$%han@samsung.com>
	 <20131112005628.GA2914@khazad-dum.debian.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.2 (3.10.2-1.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-SA-Do-Not-Run: Yes
X-SA-Exim-Connect-IP: 2001:470:1f07:1371:6267:20ff:fec3:2318
X-SA-Exim-Mail-From: mjg59@srcf.ucam.org
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-11-11 at 22:56 -0200, Henrique de Moraes Holschuh wrote:
> On Tue, 12 Nov 2013, Jingoo Han wrote:
> > 'thinkpad_acpi.c' uses the 'BACKLIGHT_UPDATE_SYSFS'.
> > Henrique, can we remove it?
> 
> Can't you fix this by rate-limiting, or otherwise adding an attribute that
> backlight devices should set when they need to supress change events?

It looks like this is just to force synchronisation to sysfs when using
the /proc interface? In which case we should probably just kill
the /proc interface.

-- 
Matthew Garrett <matthew.garrett@nebula.com>

