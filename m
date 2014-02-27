Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754140AbaB0Brr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 20:47:47 -0500
Received: from know-smtprelay-omc-8.server.virginmedia.net ([80.0.253.72]:55702
	"EHLO know-smtprelay-omc-8.server.virginmedia.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751700AbaB0Brq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 20:47:46 -0500
X-Originating-IP: [81.106.150.188]
X-Spam: 0
X-Authority: v=2.1 cv=Rs1LLUWK c=1 sm=1 tr=0 a=DGj713NdaxKrsjjgQne7PA==:117
 a=DGj713NdaxKrsjjgQne7PA==:17 a=M1kyBYkWWGkA:10 a=IVxCAUdSCW8A:10
 a=uObrxnre4hsA:10 a=IkcTkHD0fZMA:10 a=NLZqzBF-AAAA:8 a=S4CjxF9jpiAA:10
 a=ogruEA3K7mPRLwxbs18A:9 a=QEXdDO2ut3YA:10
Date: Thu, 27 Feb 2014 01:47:44 +0000
From: Ken Moffat <zarniwhoop@ntlworld.com>
To: Gene Heskett <gheskett@wdtv.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: 3.13.5 : rm -rf running forever, one cpu at approx 100%
Message-ID: <20140227014744.GA12070@milliways>
References: <20140227005246.GB10367@milliways>
 <201402262028.29352.gheskett@wdtv.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <201402262028.29352.gheskett@wdtv.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 26, 2014 at 08:28:29PM -0500, Gene Heskett wrote:
> On Wednesday 26 February 2014, Ken Moffat wrote:
> 
> I don't have any help to offer Ken, but this walks and quacks much like a 
> duck I'm encountering in 3.13.5, with the backup program amanda, which uses 
> gnu tar.  To facilitate intelligent guesses as to the size of the various 
> levels of backup, amanda does a dummy collection using tar, sent to 
> /dev/null, using only the size it reports on the first pass.  Version 1.22, 
> quite old, works on 3.12.9, but not on 3.13.5.  I have now pulled in, built 
> and installed tar-1.27, and rebuilt amanda to let it know that the tar its 
> using is not in /usr/bin, but in /usr/local/bin.  Next run at 1:30AM
> 
> This freeze, using 100% of a core, but causing no visible disk activity has 
> killed my backups 3 nights running.  At this point I've no clue as to the 
> cause, but I will be watching this thread closely, it has a similar 
> description.
> 
> Cheers, Gene

 My box where I see this is a phenom (my intel is still on 3.13.4),
and from past threads I suspect yours is as well ?

ĸen
-- 
das eine Mal als Tragödie, dieses Mal als Farce
