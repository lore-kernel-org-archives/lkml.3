Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751242AbaDOHri (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 03:47:38 -0400
Received: from cpsmtpb-ews10.kpnxchange.com ([213.75.39.15]:58266 "EHLO
	cpsmtpb-ews10.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750975AbaDOHrh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 03:47:37 -0400
Message-ID: <1397548054.1985.3.camel@x220>
Subject: Re: [PATCH 07/28] Remove CPU_PXA988
From: Paul Bolle <pebolle@tiscali.nl>
To: Richard Weinberger <richard@nod.at>
Cc: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        FRAMEBUFFER LAYER <linux-fbdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Date: Tue, 15 Apr 2014 09:47:34 +0200
In-Reply-To: <52F800B2.6010702@nod.at>
References: <1391971686-9517-1-git-send-email-richard@nod.at>
		 <1391971686-9517-8-git-send-email-richard@nod.at>
	 <1391984646.25855.79.camel@x220> <52F800B2.6010702@nod.at>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-2.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 15 Apr 2014 07:47:34.0746 (UTC) FILETIME=[F6D743A0:01CF587E]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Richard,

On Sun, 2014-02-09 at 23:26 +0100, Richard Weinberger wrote:
> Am 09.02.2014 23:24, schrieb Paul Bolle:
> > On Sun, 2014-02-09 at 19:47 +0100, Richard Weinberger wrote:
> >> The symbol is an orphan, get rid of it.
> >>
> >> Signed-off-by: Richard Weinberger <richard@nod.at>
> > 
> > This one first entered the tree in v3.9, with commit 59393bb94c10
> > ("video: mmp display subsystem"). The Kconfig symbol has not yet been
> > added.
> 
> Thanks a lot for digging out the background info!
> I'll add them to the commit message.

Did you ever find the time to update the commit message? If not, should
I submit an updated version of this patch?


Paul Bolle

