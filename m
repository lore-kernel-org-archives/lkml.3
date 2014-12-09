Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753946AbaLIWub (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2014 17:50:31 -0500
Received: from bh-25.webhostbox.net ([208.91.199.152]:56516 "EHLO
	bh-25.webhostbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753618AbaLIWu0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2014 17:50:26 -0500
Date: Tue, 9 Dec 2014 14:49:02 -0800
From: Guenter Roeck <linux@roeck-us.net>
To: Pali =?iso-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>
Cc: Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jean Delvare <jdelvare@suse.de>,
        Gabriele Mazzotta <gabriele.mzt@gmail.com>,
        Steven Honeyman <stevenhoneyman@gmail.com>,
        Jochen Eisinger <jochen@penguin-breeder.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] i8k: cosmetic: distinguish between fan speed and fan
 rpm
Message-ID: <20141209224902.GA23006@roeck-us.net>
References: <1418155621-21644-1-git-send-email-pali.rohar@gmail.com>
 <1418155621-21644-2-git-send-email-pali.rohar@gmail.com>
 <20141209202304.GB22176@roeck-us.net>
 <201412092139.29655@pali>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <201412092139.29655@pali>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Authenticated_sender: guenter@roeck-us.net
X-OutGoing-Spam-Status: No, score=-1.0
X-CTCH-PVer: 0000001
X-CTCH-Spam: Unknown
X-CTCH-VOD: Unknown
X-CTCH-Flags: 0
X-CTCH-RefID: str=0001.0A010204.54877CB2.0161,ss=1,re=0.001,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0
X-CTCH-Score: 0.001
X-CTCH-ScoreCust: 0.000
X-CTCH-Rules: C_4847,
X-CTCH-SenderID: linux@roeck-us.net
X-CTCH-SenderID-Flags: 0
X-CTCH-SenderID-TotalMessages: 8
X-CTCH-SenderID-TotalSpam: 0
X-CTCH-SenderID-TotalSuspected: 0
X-CTCH-SenderID-TotalConfirmed: 0
X-CTCH-SenderID-TotalBulk: 0
X-CTCH-SenderID-TotalVirus: 0
X-CTCH-SenderID-TotalRecipients: 0
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - bh-25.webhostbox.net
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - roeck-us.net
X-Get-Message-Sender-Via: bh-25.webhostbox.net: mailgid no entry from get_relayhosts_entry
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 09, 2014 at 09:39:29PM +0100, Pali Rohár wrote:
> On Tuesday 09 December 2014 21:23:04 Guenter Roeck wrote:
> > On Tue, Dec 09, 2014 at 09:06:59PM +0100, Pali Rohár wrote:
> > > Driver mix speed and rpm. Fan speed is value (0, 1, 2) which
> > > is used for configuring fan. This patch change comments,
> > > function names and other definitions so code should be
> > > unambiguous now.
> > > 
> > > Signed-off-by: Pali Rohár <pali.rohar@gmail.com>
> > > ---
> > > This patch is cosmetic and does not bring any change to
> > > code.
> > 
> > For me "speed" and "rpm" are synonyms. So you are not really
> > clarifying anything. If anything, you make the code even more
> > confusing.
> > 
> > Guenter
> 
> Ok, what do you want to use instead "speed" and "rpm" to make it 
> clear? We have function which returns RPM and other functions 
> which get/set fan speed value (which is 0, 1 or 2). And new 
> function (from patch 2) returns nominal RPM for fan speed value.
> 
I would not touch the existing code at all.

Guenter
