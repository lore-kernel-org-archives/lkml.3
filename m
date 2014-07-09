Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756244AbaGIQdG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 12:33:06 -0400
Received: from www.linutronix.de ([62.245.132.108]:43108 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751778AbaGIQdB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 12:33:01 -0400
Message-ID: <53BD6EB3.4020305@linutronix.de>
Date: Wed, 09 Jul 2014 18:32:51 +0200
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.0
MIME-Version: 1.0
To: Tony Lindgren <tony@atomide.com>
CC: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        balbi@ti.com, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, mika.westerberg@linux.intel.com
Subject: Re: [RFC PATCH 3/4] tty: serial: 8250 core: add runtime pm
References: <1404491651-1388-1-git-send-email-bigeasy@linutronix.de> <1404491651-1388-3-git-send-email-bigeasy@linutronix.de> <20140707142056.46f61cf9@alan.etchedpixels.co.uk> <20140709111705.GR28884@atomide.com> <53BD291D.3040307@linutronix.de> <20140709114837.GU28884@atomide.com> <53BD38D3.2000204@linutronix.de> <20140709151242.GY28884@atomide.com>
In-Reply-To: <20140709151242.GY28884@atomide.com>
X-Enigmail-Version: 1.6+git0.20140323
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/09/2014 05:12 PM, Tony Lindgren wrote:
> And also please note that for runtime PM the wake-up events need
> to be always enabled, so the device_may_wakeup() checks should
> be only implemented for suspend and resume. I think I got that
> corrected for most part in omap-serial.c recently, but knowing
> that might reduce the confusion a bit :)

Ehm. I also added it to omap_8250_pm() as it is done in omap-serial (in
serial_omap_pm()). Should I get rid of it in the latter?

Sebastian
