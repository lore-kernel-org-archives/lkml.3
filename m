Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760707Ab3ICTf7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Sep 2013 15:35:59 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:59404 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753720Ab3ICTf4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Sep 2013 15:35:56 -0400
Date: Tue, 3 Sep 2013 20:35:47 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Tom Gundersen <teg@jklm.no>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] input: allow SERIO=m even without EXPERT=y
Message-ID: <20130903193547.GA8150@srcf.ucam.org>
References: <1378147630-12471-1-git-send-email-teg@jklm.no>
 <20130903150226.GA2392@srcf.ucam.org>
 <CAG-2HqVK+nH4+AFrBUmr6wp1zfTeUdLArmXxZxC4TwuPSSkKZg@mail.gmail.com>
 <20130903192421.GA26734@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130903192421.GA26734@core.coreip.homeip.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 03, 2013 at 12:24:21PM -0700, Dmitry Torokhov wrote:

> Presumably such systems would carry over their .config which would have
> these as built-in.

Yeah, but distributions should still be given guidance on their default 
configs.

> i8042 is old-style platform driver, so nothing will load it if it is
> compiled as a module. This one worries me most.

We could add the PNP aliases for it.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
