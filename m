Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752899AbaBQJK6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 04:10:58 -0500
Received: from e06smtp16.uk.ibm.com ([195.75.94.112]:58705 "EHLO
	e06smtp16.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752243AbaBQJK0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 04:10:26 -0500
Date: Mon, 17 Feb 2014 10:10:21 +0100
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>, linux390@de.ibm.com,
        linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] s390: remove HAVE_MARCH_Z9?0_FEATURES
Message-ID: <20140217091021.GB4651@osiris>
References: <1392570927.28866.12.camel@x220>
 <20140217082035.GA4651@osiris>
 <1392627040.10966.18.camel@x220>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1392627040.10966.18.camel@x220>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14021709-3548-0000-0000-000008182C4D
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 17, 2014 at 09:50:40AM +0100, Paul Bolle wrote:
> On Mon, 2014-02-17 at 09:20 +0100, Heiko Carstens wrote:
> > On Sun, Feb 16, 2014 at 06:15:27PM +0100, Paul Bolle wrote:
> > No, I want to keep them, so there is a config symbol for each cpu generation
> > and we don't have to add the config symbols again, if we actually use them.
> 
> Yes, that's the idea: only add Kconfig symbols that you are actually
> going to use.
> 
> > It's a question of completeness in this case, not if they are being used.
> 
> Completeness of what?

Each cpu generation we support is supposed to have a
"HAVE_MARCH_<GENERATION>_FEATURES" config symbol.

> Anyhow, perhaps you can comment this stuff out if you want to have it in
> the tree. See, these symbols will pop up each time that people run their
> scripts to discover problems in the kconfig space. I suppose this was
> probably not the first time these two were reported. And people not
> aware of this thread might do that again, and again...

What script did you use?

