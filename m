Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755884AbaJUPvA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 11:51:00 -0400
Received: from bh-25.webhostbox.net ([208.91.199.152]:47174 "EHLO
	bh-25.webhostbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755209AbaJUPu7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 11:50:59 -0400
Date: Tue, 21 Oct 2014 08:50:47 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Johan Hovold <johan@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        Alan Cox <gnomes@lxorguk.ukuu.org.uk>, Alexander Graf <agraf@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Heiko Stuebner <heiko@sntech.de>, Lee Jones <lee.jones@linaro.org>,
        Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>,
        Philippe =?iso-8859-1?Q?R=E9tornaz?= 
	<philippe.retornaz@gmail.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Romain Perier <romain.perier@gmail.com>
Subject: Re: [PATCH v2 01/47] kernel: Add support for poweroff handler call
 chain
Message-ID: <20141021155047.GA3453@roeck-us.net>
References: <1413864783-3271-1-git-send-email-linux@roeck-us.net>
 <1413864783-3271-2-git-send-email-linux@roeck-us.net>
 <20141021093405.GA2113@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141021093405.GA2113@localhost>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Authenticated_sender: guenter@roeck-us.net
X-OutGoing-Spam-Status: No, score=-1.0
X-CTCH-PVer: 0000001
X-CTCH-Spam: Unknown
X-CTCH-VOD: Unknown
X-CTCH-Flags: 0
X-CTCH-RefID: str=0001.0A020205.544680DD.004B,ss=1,re=0.000,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0
X-CTCH-Score: 0.000
X-CTCH-ScoreCust: 0.000
X-CTCH-Rules: C_4847,
X-CTCH-SenderID: linux@roeck-us.net
X-CTCH-SenderID-Flags: 0
X-CTCH-SenderID-TotalMessages: 2
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

On Tue, Oct 21, 2014 at 11:34:05AM +0200, Johan Hovold wrote:
> On Mon, Oct 20, 2014 at 09:12:17PM -0700, Guenter Roeck wrote:
> 
> > v2:
> > - poweroff -> power_off
> 
> Do you want to stick to power[-_ ]off consistently throughout?
> 

The string "poweroff" is used 819 times in today's upstream kernel.
"power_off" is used 1,496 times, presumably mostly in variable names.
"power-off" is used 145 times.

So, yes, I can change all newly introduced variable and function names
from poweroff to power_off, and all newly introduced descriptive text
from poweroff to power-off if that makes you happy. It won't improve
consistency, though, since many of the current poweroff functions
are named "something_poweroff". Hope you don't expect me to change
all those function names as well.

Guenter
