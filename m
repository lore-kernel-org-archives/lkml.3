Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754988AbaJGUdz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 16:33:55 -0400
Received: from bh-25.webhostbox.net ([208.91.199.152]:47387 "EHLO
	bh-25.webhostbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753025AbaJGUdy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 16:33:54 -0400
Date: Tue, 7 Oct 2014 13:33:44 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: David Miller <davem@davemloft.net>
Cc: fabf@skynet.be, linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH 1/1 net-next] af_unix: remove NULL assignment on static
Message-ID: <20141007203344.GA4748@roeck-us.net>
References: <1412712996-4672-1-git-send-email-fabf@skynet.be>
 <20141007.161832.453892039501955243.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141007.161832.453892039501955243.davem@davemloft.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Authenticated_sender: guenter@roeck-us.net
X-OutGoing-Spam-Status: No, score=-1.0
X-CTCH-PVer: 0000001
X-CTCH-Spam: Unknown
X-CTCH-VOD: Unknown
X-CTCH-Flags: 0
X-CTCH-RefID: str=0001.0A020207.54344E31.0112,ss=1,re=0.000,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0
X-CTCH-Score: 0.000
X-CTCH-ScoreCust: 0.000
X-CTCH-Rules: 
X-CTCH-SenderID: linux@roeck-us.net
X-CTCH-SenderID-Flags: 0
X-CTCH-SenderID-TotalMessages: 3
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

On Tue, Oct 07, 2014 at 04:18:32PM -0400, David Miller wrote:
> From: Fabian Frederick <fabf@skynet.be>
> Date: Tue,  7 Oct 2014 22:16:36 +0200
> 
> > static values are automatically initialized to NULL
> > 
> > Signed-off-by: Fabian Frederick <fabf@skynet.be>
> 
> Isn't there some implementation room given to compilers
> as to the representation of true and false?

Not for true/false.

C99 standard, section 7.16:

...
The remaining three macros are suitable for use in #if preprocessing
directives. They are

true

which expands to the integer constant 1,

false

which expands to the integer constant 0, and
...

No idea where the NULL comes into the picture, though.

Guenter
