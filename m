Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757198Ab3ENMeW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 May 2013 08:34:22 -0400
Received: from mga14.intel.com ([143.182.124.37]:57972 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752085Ab3ENMeV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 May 2013 08:34:21 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,670,1363158000"; 
   d="scan'208";a="302232541"
From: Alexander Shishkin <alexander.shishkin@linux.intel.com>
To: Shawn Guo <shawn.guo@linaro.org>
Cc: Fabio Estevam <fabio.estevam@freescale.com>, kernel@pengutronix.de,
        festevam@gmail.com, Thierry Reding <thierry.reding@avionic-design.de>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 06/13] pwm: pwm-mxs: Let device core handle pinctrl
In-Reply-To: <20130508135317.GB26072@S2101-09.ap.freescale.net>
References: <1367863561-11534-1-git-send-email-fabio.estevam@freescale.com> <1367863561-11534-6-git-send-email-fabio.estevam@freescale.com> <87d2t1n0ze.fsf@ashishki-desk.ger.corp.intel.com> <20130508135317.GB26072@S2101-09.ap.freescale.net>
User-Agent: Notmuch/0.12+187~ga2502b0 (http://notmuchmail.org) Emacs/23.4.1 (x86_64-pc-linux-gnu)
Date: Tue, 14 May 2013 15:33:59 +0300
Message-ID: <87txm5lozs.fsf@ashishki-desk.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Shawn Guo <shawn.guo@linaro.org> writes:

> On Wed, May 08, 2013 at 02:51:33PM +0300, Alexander Shishkin wrote:
>> Fabio Estevam <fabio.estevam@freescale.com> writes:
>> 
>> > Since commit ab78029 (drivers/pinctrl: grab default handles from device core),
>> > we can rely on device core for handling pinctrl.
>> >
>> > So remove devm_pinctrl_get_select_default() from the driver. 
>> >
>> > Cc: Thierry Reding <thierry.reding@avionic-design.de>
>> > Cc: <linux-kernel@vger.kernel.org>
>> > Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>
>> > ---
>> >  drivers/pwm/pwm-mxs.c |    6 ------
>> >  1 file changed, 6 deletions(-)
>> 
>> Looks good, can we have some tested-by from imx guys?
>
> I'm not sure why you're interested in this patch instead of
> "[PATCH 01/13] usb: chipidea: ci13xxx_imx: Let device core handle
> pinctrl".  I tested both patches, so

I don't seem to have this one in either of my mailboxes.

> Tested-by: Shawn Guo <shawn.guo@linaro.org>

Thank you.
