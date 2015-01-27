Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932945AbbA0T4H (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 14:56:07 -0500
Received: from relais.videotron.ca ([24.201.245.36]:16899 "EHLO
	relais.videotron.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758819AbbA0T4D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 14:56:03 -0500
X-Greylist: delayed 901 seconds by postgrey-1.27 at vger.kernel.org; Tue, 27 Jan 2015 14:56:03 EST
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN; CHARSET=US-ASCII
Date: Tue, 27 Jan 2015 14:40:54 -0500 (EST)
From: Nicolas Pitre <nico@fluxnic.net>
To: Pavel Machek <pavel@ucw.cz>
Cc: Rob Herring <robherring2@gmail.com>,
        =?ISO-8859-15?Q?Pali_Roh=E1r?= <pali.rohar@gmail.com>,
        Russell King <linux@arm.linux.org.uk>,
        Will Deacon <will.deacon@arm.com>,
        Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>,
        Sebastian Reichel <sre@debian.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Tony Lindgren <tony@atomide.com>
Subject: Re: [PATCH] ARM: /proc/atags: Export also for DT
In-reply-to: <20150127132127.GA869@amd>
Message-id: <alpine.LFD.2.11.1501271439020.1322@knanqh.ubzr>
References: <1403110464-29646-1-git-send-email-pali.rohar@gmail.com>
 <201412041857.49341@pali>
 <CAL_JsqJ9i0jwaL1cyeomQG=bhhcnEgdGWYOqkcwidyk5xOUukg@mail.gmail.com>
 <201501262016.52079@pali>
 <CAL_JsqL_EEg7tC-q8wV5v8jAfPSiri4z19iJfz2r7zntRwPyOg@mail.gmail.com>
 <20150127132127.GA869@amd>
User-Agent: Alpine 2.11 (LFD 23 2013-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 27 Jan 2015, Pavel Machek wrote:

> On Mon 2015-01-26 14:33:21, Rob Herring wrote:
> > These would be non-standard fields which are not upstream. I don't
> > know that we care in that case...
> 
> Other devices are going to care about boot reason, too, and we might
> as well be compatible...

Care to elaborate on that statement please?  What does this have to do 
with ATAGs?


Nicolas
