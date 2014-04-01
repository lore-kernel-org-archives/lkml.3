Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751757AbaDAUeG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 16:34:06 -0400
Received: from cpsmtpb-ews04.kpnxchange.com ([213.75.39.7]:61278 "EHLO
	cpsmtpb-ews04.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751549AbaDAUeE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 16:34:04 -0400
Message-ID: <1396384443.23763.24.camel@x220>
Subject: Re: [git pull] Devicetree changes for v3.15
From: Paul Bolle <pebolle@tiscali.nl>
To: Rob Herring <robherring2@gmail.com>
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Rob Herring <rob.herring@linaro.org>
Date: Tue, 01 Apr 2014 22:34:03 +0200
In-Reply-To: <CAL_JsqKyLPa9PhNbzda1iPyLjfvQpsUMLR7sGRegYmLsrkY-LQ@mail.gmail.com>
References: <CACxGe6vCrkHPL6UNy1p8AO4+z5VFRY6w4_2grQEZQwp_3jJ7Yw@mail.gmail.com>
	 <1396381357.23763.16.camel@x220>
	 <CAL_JsqKyLPa9PhNbzda1iPyLjfvQpsUMLR7sGRegYmLsrkY-LQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-2.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 01 Apr 2014 20:34:03.0545 (UTC) FILETIME=[B8849890:01CF4DE9]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-04-01 at 15:18 -0500, Rob Herring wrote:
> On Tue, Apr 1, 2014 at 2:42 PM, Paul Bolle <pebolle@tiscali.nl> wrote:
> > That commit leaves a select for PROC_DEVICETREE dangling. See "config
> > ARCH_OMAP2PLUS" in arch/arm/mach-omap2/Kconfig. Can that select
> > statement just be dropped now or is something more elaborate needed?
> 
> Yes, it can and should be dropped. It never should have been there to
> begin with. It should be a user selectable option, not a platform
> selection.

Should I draft a (trivial) patch to drop it or would you like to do
that? (Your commit explanation will probably end up more useful.)


Paul Bolle

