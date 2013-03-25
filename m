Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756774Ab3CYKaK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Mar 2013 06:30:10 -0400
Received: from mail-wg0-f51.google.com ([74.125.82.51]:44550 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755917Ab3CYKaJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Mar 2013 06:30:09 -0400
Date: Mon, 25 Mar 2013 11:30:04 +0100
From: Paolo Pisati <p.pisati@gmail.com>
To: Rob Herring <robherring2@gmail.com>
Cc: Paolo Pisati <p.pisati@gmail.com>, linux-arm-kernel@lists.infradead.org,
        Russell King <linux@arm.linux.org.uk>,
        Jason Cooper <jason@lakedaemon.net>, Will Deacon <will.deacon@arm.com>,
        linux-kernel@vger.kernel.org, Rob Herring <rob.herring@calxeda.com>,
        Gregory CLEMENT <gregory.clement@free-electrons.com>
Subject: Re: [PATCH] ARM: l2x0: don't set .set_debug in l310 case
Message-ID: <20130325103004.GB3330@luxor.wired.org>
References: <1364149654-16163-1-git-send-email-p.pisati@gmail.com>
 <514F6CD1.5010409@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <514F6CD1.5010409@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 24, 2013 at 04:14:57PM -0500, Rob Herring wrote:
> On 03/24/2013 01:27 PM, Paolo Pisati wrote:
> > From: Paolo Pisati <paolo.pisati@canonical.com>
> > 
> > commit 74ddcdb ("l2x0: Only set .set_debug on PL310 r3p0 and earlier")
> > to actually work needs .set_debug to be not set during definition
> > 
> > Signed-off-by: Paolo Pisati <p.pisati@gmail.com>
> 
> Ah crap, missed this part. Can I add this into my fix and I'll put it in
> Russell's patch system.

Of course, go ahead.
-- 
bye,
p.
