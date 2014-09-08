Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754902AbaIHVq2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 17:46:28 -0400
Received: from mail-pd0-f169.google.com ([209.85.192.169]:63100 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754254AbaIHVq1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 17:46:27 -0400
Date: Mon, 8 Sep 2014 14:46:23 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Klaus Goger <klaus.goger@theobroma-systems.com>
Cc: Daniel Mack <zonque@gmail.com>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Input: cap1106 - fix register definition
Message-ID: <20140908214623.GF24033@core.coreip.homeip.net>
References: <1409639544-30420-1-git-send-email-klaus.goger@theobroma-systems.com>
 <54057526.9050503@gmail.com>
 <53EB1EFA-3BFF-4818-A524-B3ED3CF62D56@theobroma-systems.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53EB1EFA-3BFF-4818-A524-B3ED3CF62D56@theobroma-systems.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 02, 2014 at 01:01:11PM +0200, Klaus Goger wrote:
> On Sep 2, 2014, at 9:43 AM, Daniel Mack <zonque@gmail.com> wrote:
> > On 09/02/2014 08:32 AM, Klaus Goger wrote:
> >> Use the correct register address for Calibration Active and Interrupt
> >> Enable
> >> 
> >> Signed-off-by: Klaus Goger <klaus.goger@theobroma-systems.com>
> > 
> > These register definitions are currently unused, but your fix is
> > correct. Just curious - are you planning to send patches that make use
> > of them?
> 
> I want to use CAP1106_REG_SENSITIVITY_CONTROL but I have yet to
> decide how to expose it to the user. Probably adding another device tree
> option. But somehow it feels like cluttering up the dts.
> Once I have settled about that I will send patches.

Applied, thank you.

-- 
Dmitry
