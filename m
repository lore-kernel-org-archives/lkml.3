Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752264AbbATOod (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 09:44:33 -0500
Received: from mail-ig0-f178.google.com ([209.85.213.178]:32998 "EHLO
	mail-ig0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751772AbbATOoc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 09:44:32 -0500
Date: Tue, 20 Jan 2015 14:44:26 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Fabio Estevam <festevam@gmail.com>
Cc: Mark Brown <broonie@kernel.org>, Samuel Ortiz <sameo@linux.intel.com>,
        anthony.olech.opensource@diasemi.com, support.opensource@diasemi.com,
        johan@kernel.org, linux-kernel <linux-kernel@vger.kernel.org>,
        Fabio Estevam <fabio.estevam@freescale.com>
Subject: Re: [PATCH] mfd: da9052-core: Fix platform-device id collision
Message-ID: <20150120144426.GU13701@x1>
References: <1418175593-23474-1-git-send-email-festevam@gmail.com>
 <20141210094649.GA23481@x1>
 <20141210111925.GP11764@sirena.org.uk>
 <20141210121125.GC23481@x1>
 <CAOMZO5DVOojrVoM1X6fRDfoNc50b8nPtv7Bu=rFYGBpXMbkiJQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAOMZO5DVOojrVoM1X6fRDfoNc50b8nPtv7Bu=rFYGBpXMbkiJQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 23 Dec 2014, Fabio Estevam wrote:
> On Wed, Dec 10, 2014 at 10:11 AM, Lee Jones <lee.jones@linaro.org> wrote:
> 
> > My train of thought was that the original configuration has not
> > changed since 2011.  I guess other regulators have been recently
> > introduced.  Very well, applied to -fixes.
> 
> Still don't see this patch in linux-next.

Sorry for the delay, I have been on vacation.

I sent out my -fixes branch to Linus this morning.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
