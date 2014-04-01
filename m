Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751772AbaDAUSj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 16:18:39 -0400
Received: from mail-vc0-f181.google.com ([209.85.220.181]:39920 "EHLO
	mail-vc0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751720AbaDAUSh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 16:18:37 -0400
MIME-Version: 1.0
In-Reply-To: <1396381357.23763.16.camel@x220>
References: <CACxGe6vCrkHPL6UNy1p8AO4+z5VFRY6w4_2grQEZQwp_3jJ7Yw@mail.gmail.com>
	<1396381357.23763.16.camel@x220>
Date: Tue, 1 Apr 2014 15:18:36 -0500
Message-ID: <CAL_JsqKyLPa9PhNbzda1iPyLjfvQpsUMLR7sGRegYmLsrkY-LQ@mail.gmail.com>
Subject: Re: [git pull] Devicetree changes for v3.15
From: Rob Herring <robherring2@gmail.com>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Rob Herring <rob.herring@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 1, 2014 at 2:42 PM, Paul Bolle <pebolle@tiscali.nl> wrote:
> On Tue, 2014-04-01 at 11:15 +0100, Grant Likely wrote:
>> Grant Likely (13):
>>       [...]
>>       of: remove /proc/device-tree
>
> That commit leaves a select for PROC_DEVICETREE dangling. See "config
> ARCH_OMAP2PLUS" in arch/arm/mach-omap2/Kconfig. Can that select
> statement just be dropped now or is something more elaborate needed?

Yes, it can and should be dropped. It never should have been there to
begin with. It should be a user selectable option, not a platform
selection.

Rob
