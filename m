Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751955AbaL3Hfg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Dec 2014 02:35:36 -0500
Received: from bh-25.webhostbox.net ([208.91.199.152]:55738 "EHLO
	bh-25.webhostbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751605AbaL3Hff (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Dec 2014 02:35:35 -0500
Date: Mon, 29 Dec 2014 23:35:07 -0800
From: Guenter Roeck <linux@roeck-us.net>
To: Gabriele Mazzotta <gabriele.mzt@gmail.com>
Cc: Pali =?iso-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jean Delvare <jdelvare@suse.de>,
        Steven Honeyman <stevenhoneyman@gmail.com>,
        Jochen Eisinger <jochen@penguin-breeder.org>,
        linux-kernel@vger.kernel.org, Valdis.Kletnieks@vt.edu
Subject: Re: [PATCH 3/3] i8k: Remove laptop specific config data (fan_mult,
 fan_max) from driver
Message-ID: <20141230073507.GA11067@roeck-us.net>
References: <1418155621-21644-1-git-send-email-pali.rohar@gmail.com>
 <1566138.nEi3x1Fh8B@xps13>
 <201412291322.52203@pali>
 <1452807.aaSs3acGZG@xps13>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1452807.aaSs3acGZG@xps13>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Authenticated_sender: guenter@roeck-us.net
X-OutGoing-Spam-Status: No, score=-1.0
X-CTCH-PVer: 0000001
X-CTCH-Spam: Unknown
X-CTCH-VOD: Unknown
X-CTCH-Flags: 0
X-CTCH-RefID: str=0001.0A020205.54A255CB.009B,ss=1,re=0.001,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0
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

On Mon, Dec 29, 2014 at 01:50:22PM +0100, Gabriele Mazzotta wrote:
> On Monday 29 December 2014 13:22:52 Pali Rohár wrote:
> > On Sunday 28 December 2014 17:17:14 Gabriele Mazzotta wrote:
> > > OK, I wanted to double check in case I had something missing.
> > > 
> > > Patches tested on my XPS13: the correct values for fan_mult
> > > and fan_man are automatically selected.
> > 
> > Great. Are there any other problems? Now probe time when loading 
> > module should be lower and could not freeze system, right?
> 
> Yes, the system doesn't hang on module load. The only problem I have
> right night now is that the system temporarily hangs when I read or set
> the speed of the fan.

This is a known problem on some Dell laptops; one of mine has the same problem.
Nothing we can do about that, unfortunately. Only thing you can do is
to not read the fan speed.

Guenter
