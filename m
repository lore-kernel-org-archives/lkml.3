Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753286Ab3GPHyd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jul 2013 03:54:33 -0400
Received: from cpsmtpb-ews04.kpnxchange.com ([213.75.39.7]:54689 "EHLO
	cpsmtpb-ews04.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752436Ab3GPHyc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jul 2013 03:54:32 -0400
Message-ID: <1373961269.2591.50.camel@x61.thuisdomein>
Subject: Re: [PATCH] sh: remove references to CPU_SUBTYPE_SH7764
From: Paul Bolle <pebolle@tiscali.nl>
To: Paul Mundt <lethal@linux-sh.org>
Cc: linux-sh@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Tue, 16 Jul 2013 09:54:29 +0200
In-Reply-To: <20130312075747.GB3553@linux-sh.org>
References: <1363002940.3137.65.camel@x61.thuisdomein>
	 <20130312075747.GB3553@linux-sh.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 16 Jul 2013 07:54:30.0021 (UTC) FILETIME=[B3977350:01CE81F9]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul,

On Tue, 2013-03-12 at 16:57 +0900, Paul Mundt wrote:
> On Mon, Mar 11, 2013 at 12:55:40PM +0100, Paul Bolle wrote:
> > Since release v2.6.29 the tree has a few references to the Kconfig
> > symbol CPU_SUBTYPE_SH7764 and the Kconfig macro
> > CONFIG_CPU_SUBTYPE_SH7764. But the actual symbol CPU_SUBTYPE_SH7764 was
> > never added to the tree. Perhaps no one noticed because these references
> > were never used alone. Anyhow, these references serve no purpose and
> > can be removed.
> > 
> > Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
> 
> Looks fine, I suspect Iwamatsu-san let this trickle in from some vendor
> branch given that these are all his drivers. I'll queue it up, thanks.

This didn't (yet) make it into mainline. Is there an issue with this
patch? Or is it queued somewhere?


Paul Bolle

