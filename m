Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758238AbbA2O0w (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 09:26:52 -0500
Received: from guitar.tcltek.co.il ([192.115.133.116]:57549 "EHLO
	mx.tkos.co.il" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758140AbbA2O0v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 09:26:51 -0500
Date: Thu, 29 Jan 2015 16:26:39 +0200
From: Baruch Siach <baruch@tkos.co.il>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: Daniel Lezcano <daniel.lezcano@linaro.org>, tglx@linutronix.de,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Barry.Song@csr.com, linux@rempel-privat.de, rob.herring@linaro.org,
        thierry.reding@gmail.com
Subject: Re: [PATCH 6/9] clocksource: Driver for Conexant Digicolor SoC timer
Message-ID: <20150129142639.GI19448@tarshish>
References: <54CA3044.6070501@linaro.org>
 <1422536899-16609-1-git-send-email-daniel.lezcano@linaro.org>
 <1422536899-16609-6-git-send-email-daniel.lezcano@linaro.org>
 <1422538656.32520.4.camel@x220>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1422538656.32520.4.camel@x220>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Paul,

On Thu, Jan 29, 2015 at 02:37:36PM +0100, Paul Bolle wrote:
> On Thu, 2015-01-29 at 14:08 +0100, Daniel Lezcano wrote:
> > From: Baruch Siach <baruch@tkos.co.il>
> > +config DIGICOLOR_TIMER
> > +	bool
> 
> And the select for this symbol (see https://lkml.org/lkml/2015/1/26/360)
> will be provided in a separate patch? Because this patch, by itself,
> won't allow DIGICOLOR_TIMER to be set, will it?

Yes. Posted yesterday. See 
http://article.gmane.org/gmane.linux.ports.arm.kernel/390166.

baruch

-- 
     http://baruch.siach.name/blog/                  ~. .~   Tk Open Systems
=}------------------------------------------------ooO--U--Ooo------------{=
   - baruch@tkos.co.il - tel: +972.2.679.5364, http://www.tkos.co.il -
