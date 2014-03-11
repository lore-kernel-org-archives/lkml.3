Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754358AbaCKQaz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 12:30:55 -0400
Received: from perceval.ideasonboard.com ([95.142.166.194]:54084 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753073AbaCKQav (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 12:30:51 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Mark Brown <broonie@kernel.org>, linux-spi <linux-spi@vger.kernel.org>,
        Linux-sh list <linux-sh@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Geert Uytterhoeven <geert+renesas@linux-m68k.org>,
        Magnus Damm <magnus.damm@gmail.com>
Subject: Re: [PATCH 2/3] spi: sh-msiof: Convert to spi core auto_runtime_pm framework
Date: Tue, 11 Mar 2014 17:32:26 +0100
Message-ID: <2274545.CyQ67zvVqo@avalon>
User-Agent: KMail/4.11.5 (Linux/3.10.25-gentoo; KDE/4.11.5; x86_64; ; )
In-Reply-To: <CAMuHMdVOUuFsObEag_MwUT_jaqfOHMEcUScrkbaTEitmyJr+NQ@mail.gmail.com>
References: <1394531952-3905-1-git-send-email-geert@linux-m68k.org> <1802214.NxZUiJcWLG@avalon> <CAMuHMdVOUuFsObEag_MwUT_jaqfOHMEcUScrkbaTEitmyJr+NQ@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 11 March 2014 17:23:37 Geert Uytterhoeven wrote:
> Hi Laurent,
> 
> On Tue, Mar 11, 2014 at 4:55 PM, Laurent Pinchart wrote:
> > Does this require drivers/sh/pm_runtime.c to be compiled in ?
> 
> Let's check...
> 
> My koelsch-legacy kernel has drivers/sh/pm_runtime.c compiled in.
> My koelsch-reference kernel hasn't.
> 
> However, under the -reference kernel many MSTP clocks (incl. MSIOF)
> seem to be enabled all the time, while under -legacy they are enabled and
> disabled on demand.

Is PM_RUNTIME enabled in both cases ?


There's something fishy in there that we should try to fix without too further 
much delay. Ben Dooks has pointed out the problem a couple of months ago, but 
the discussion on the mailing list just died.

-- 
Regards,

Laurent Pinchart

