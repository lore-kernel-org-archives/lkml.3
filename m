Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752785AbaBXNmA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 08:42:00 -0500
Received: from imap.thunk.org ([74.207.234.97]:33491 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752399AbaBXNl5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 08:41:57 -0500
Date: Mon, 24 Feb 2014 08:41:50 -0500
From: "Theodore Ts'o" <tytso@mit.edu>
To: Michal Simek <monstr@monstr.eu>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Felipe Balbi <balbi@ti.com>,
        Subbaraya Sundeep Bhatta <subbaraya.sundeep.bhatta@xilinx.com>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Subbaraya Sundeep Bhatta <sbhatta@xilinx.com>,
        devicetree@vger.kernel.org, Wolfgang Denk <wd@denx.de>
Subject: Re: SPDX-License-Identifier
Message-ID: <20140224134150.GB25357@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	Michal Simek <monstr@monstr.eu>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Felipe Balbi <balbi@ti.com>,
	Subbaraya Sundeep Bhatta <subbaraya.sundeep.bhatta@xilinx.com>,
	linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
	Subbaraya Sundeep Bhatta <sbhatta@xilinx.com>,
	devicetree@vger.kernel.org, Wolfgang Denk <wd@denx.de>
References: <20140221160442.GA17506@kroah.com>
 <5307790A.4050806@monstr.eu>
 <20140221161246.GM31902@saruman.home>
 <53077C5F.9000407@monstr.eu>
 <20140221162045.GN31902@saruman.home>
 <20140221165633.GA5465@kroah.com>
 <53078C30.7060703@monstr.eu>
 <20140221175720.GA21660@kroah.com>
 <20140221190125.GL31047@thunk.org>
 <530B1B25.5090601@monstr.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <530B1B25.5090601@monstr.eu>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 24, 2014 at 11:12:53AM +0100, Michal Simek wrote:
> > But of course, I'm not a lawyer, and if your company has is paying for
> > the development of the driver, the Golden Rule applies (he who has the
> > Gold, makes the Rules), and each of our respective corporate lawyers
> > may have different opinions about what might happen if the question
> > was ever to be adjudicated in court.
> 
> Aren't all these points already answered by SPDX project?
> I believe that they should know how this should be handled properly.

The SPDX can not give legal advice; not to you, and not to your
company.  One lawyer might believe that 

/*
 * SPDX-License-Identifier: GPL-2.0
 */

Might be sufficient.  Others might believe you need to do:

/*
 * Copyright Ty Coon, 2012.
 * 
 * SPDX-License-Identifier: GPL-2.0
 */

Still others might believe you need at the very least:

/*
 * Copyright Ty Coon, 2012.
 * 
 * All Rights Reserved.
 *
 * SPDX-License-Identifier: GPL-2.0
 */

As far as I know, there is no case law on point about whether or not
SPDX-License-Identifier has legal significance, or whether the court
would consider that to be a valid copyright permission statement.  So
any "answers" made by any lawyer would be guesses.  Of course, an
guess by a lawyer which is retained by *you* or your company and fully
informed with the unique parameters of your situation would constitute
legal advice.  Anything else, including anything any of us could say
on this mailing list, would be biovating.  :-)

Cheers,

					- Ted
