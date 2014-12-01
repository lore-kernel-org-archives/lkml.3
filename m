Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754575AbaLAQWm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 11:22:42 -0500
Received: from bh-25.webhostbox.net ([208.91.199.152]:49674 "EHLO
	bh-25.webhostbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753391AbaLAQWk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 11:22:40 -0500
Date: Mon, 1 Dec 2014 08:22:32 -0800
From: Guenter Roeck <linux@roeck-us.net>
To: Jean Delvare <jdelvare@suse.de>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Pali =?iso-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>,
        linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        lm-sensors@lm-sensors.org
Subject: Re: [lm-sensors] [PATCH 3/3] i8k: Add support for Dell XPS 13
Message-ID: <20141201162232.GA23419@roeck-us.net>
References: <1417381240-7641-1-git-send-email-linux@roeck-us.net>
 <1417381240-7641-3-git-send-email-linux@roeck-us.net>
 <20141201133645.2a423043@endymion.delvare>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20141201133645.2a423043@endymion.delvare>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Authenticated_sender: guenter@roeck-us.net
X-OutGoing-Spam-Status: No, score=-1.0
X-CTCH-PVer: 0000001
X-CTCH-Spam: Unknown
X-CTCH-VOD: Unknown
X-CTCH-Flags: 0
X-CTCH-RefID: str=0001.0A020205.547C95CF.013C,ss=1,re=0.001,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0
X-CTCH-Score: 0.001
X-CTCH-ScoreCust: 0.000
X-CTCH-Rules: C_4847,
X-CTCH-SenderID: linux@roeck-us.net
X-CTCH-SenderID-Flags: 0
X-CTCH-SenderID-TotalMessages: 4
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

On Mon, Dec 01, 2014 at 01:36:45PM +0100, Jean Delvare wrote:
> On Sun, 30 Nov 2014 13:00:40 -0800, Guenter Roeck wrote:
> > XPS 13 does not support turbo speed, so its initialization data
> > matches that of XPS M140. Make XPS initialization data generic,
> > and add support for XPS 13.
> > 
> > Cc: Pali Rohár <pali.rohar@gmail.com>
> > Signed-off-by: Guenter Roeck <linux@roeck-us.net>
> > ---

[ ... ]
> 
> Looks reasonable.
> 
> Reviewed-by: Jean Delvare <jdelvare@suse.de>
> 
Thanks a lot for the reviews!

Guenter
