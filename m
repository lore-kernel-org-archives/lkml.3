Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752883Ab3FQXQo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 19:16:44 -0400
Received: from mga01.intel.com ([192.55.52.88]:58661 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751389Ab3FQXQm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 19:16:42 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,884,1363158000"; 
   d="scan'208";a="355020018"
Date: Tue, 18 Jun 2013 01:16:38 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Simon Glass <sjg@chromium.org>, Geert Uytterhoeven <geert@linux-m68k.org>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        lk <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] input: cros_ec_keyb_clear_keyboard() depends on
 CONFIG_PM_SLEEP
Message-ID: <20130617231638.GV7998@zurbaran>
References: <1368049529-8168-1-git-send-email-geert@linux-m68k.org>
 <CAPnjgZ3Akf0+LKBt4c5HQX5c8PhL+zuvvHWrDpVj0W++GiOanA@mail.gmail.com>
 <20130515064248.GB24297@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20130515064248.GB24297@core.coreip.homeip.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dmitry,

On Tue, May 14, 2013 at 11:42:48PM -0700, Dmitry Torokhov wrote:
> On Wed, May 08, 2013 at 09:25:56PM -0600, Simon Glass wrote:
> > On Wed, May 8, 2013 at 3:45 PM, Geert Uytterhoeven <geert@linux-m68k.org> wrote:
> > > If CONFIG_PM_SLEEP is not set:
> > >
> > > drivers/input/keyboard/cros_ec_keyb.c:211: warning: ‘cros_ec_keyb_clear_keyboard’ defined but not used
> > >
> > > Move the definition of cros_ec_keyb_clear_keyboard() inside the section
> > > protected by #ifdef CONFIG_PM_SLEEP to fix this.
> > >
> > > Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
> > 
> > Acked-by: Simon Glass <sjg@chromium.org>
> 
> Acked-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
> 
> Could you please forward this to Linus as I do not have this driver in
> my branch yet.
I guess you took that one now ? Or are you expecting me to merge it ?

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
