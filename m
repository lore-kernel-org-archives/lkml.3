Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757404AbaJ2Vjp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 17:39:45 -0400
Received: from bh-25.webhostbox.net ([208.91.199.152]:50032 "EHLO
	bh-25.webhostbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756291AbaJ2Vjo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 17:39:44 -0400
Date: Wed, 29 Oct 2014 14:39:28 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Florian Fainelli <f.fainelli@gmail.com>
Cc: netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Andrew Lunn <andrew@lunn.ch>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 00/15] net: dsa: Fixes and enhancements
Message-ID: <20141029213928.GA28498@roeck-us.net>
References: <1414604707-22407-1-git-send-email-linux@roeck-us.net>
 <5451305B.7010303@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5451305B.7010303@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Authenticated_sender: guenter@roeck-us.net
X-OutGoing-Spam-Status: No, score=-1.0
X-CTCH-PVer: 0000001
X-CTCH-Spam: Unknown
X-CTCH-VOD: Unknown
X-CTCH-Flags: 0
X-CTCH-RefID: str=0001.0A020207.54515E9F.011B,ss=1,re=0.000,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0
X-CTCH-Score: 0.000
X-CTCH-ScoreCust: 0.000
X-CTCH-Rules: C_4847,
X-CTCH-SenderID: linux@roeck-us.net
X-CTCH-SenderID-Flags: 0
X-CTCH-SenderID-TotalMessages: 5
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

On Wed, Oct 29, 2014 at 11:22:19AM -0700, Florian Fainelli wrote:
> On 10/29/2014 10:44 AM, Guenter Roeck wrote:
> > Patch 01/15 addresses a bug indicated by an an annoying and unhelpful
> > log message.
> > 
> > Patches 02/15 and 03/15 are minor enhancements, adding support for
> > known switch revisions.
> > 
> > Patches 04/15 and 05/15 add support for MV88E6352 and MV88E6176.
> > 
> > Patch 06/15 adds support for hardware monitoring, specifically for
> > reporting the chip temperature, to the dsa subsystem.
> > 
> > Patches 07/15 and 08/15 implement hardware monitoring for MV88E6352,
> > MV88E6176, MV88E6123, MV88E6161, and MV88E6165.
> > 
> > Patch 09/15 and 10/15 add support for EEPROM access to the DSA subsystem.
> > 
> > Patch 11/15 implements EEPROM access for MV88E6352 and MV88E6176.
> > 
> > Patch 12/15 adds support for reading switch registers to the DSA
> > subsystem.
> > 
> > Patches 13/15 amd 14/15 implement support for reading switch registers
> > to the drivers for MV88E6352, MV88E6176, MV88E6123, MV88E6161, and MV88E6165.
> > 
> > Patch 15/15 adds support for reading additional RMON registers to the drivers
> > for  MV88E6352, MV88E6176, MV88E6123, MV88E6161, and MV88E6165.
> > 
> > The series was tested on top of v3.18-rc2 in an x86 system with MV88E6352.
> > Testing in systems with 88E6131, 88E6060 and MV88E6165 was done earlier
> > (I don't have access to those systems right now). The series was also build
> > tested using my build system at http://server.roeck-us.net:8010/builders.
> > Look into the 'dsa' column for build results.
> > 
> > The series merges cleanly into net-next as of today (10/29).
> 
> Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
> 
> Thanks Guenter!
> 
Thanks a lot for the review!

Guenter
