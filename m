Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752040AbaKJIzN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 03:55:13 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:37752 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750930AbaKJIzL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 03:55:11 -0500
Date: Mon, 10 Nov 2014 09:55:09 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>,
        kernel list <linux-kernel@vger.kernel.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "Berg, Johannes" <johannes.berg@intel.com>,
        "ilw@linux.intel.com" <ilw@linux.intel.com>
Subject: Re: 3.18-rc0: iwlegacy failed after a while
Message-ID: <20141110085508.GB2582@amd>
References: <0BA3FCBA62E2DC44AF3030971E174FB31B552E3F@hasmsx107.ger.corp.intel.com>
 <20141024121240.GA3177@redhat.com>
 <20141025114246.GA16230@amd>
 <20141026103314.GB2588@redhat.com>
 <20141026110554.GA1634@amd>
 <20141028222014.GA27961@amd>
 <20141102122544.GA9242@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141102122544.GA9242@redhat.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun 2014-11-02 13:25:45, Stanislaw Gruszka wrote:
> On Tue, Oct 28, 2014 at 11:20:15PM +0100, Pavel Machek wrote:
> > > > It can be checked by "iw dev wlan0 get power_save" .
> > 
> > So it seems I have power save on. I guess someone enabled it for me :-).
> > 
> > root@duo:~# iwconfig wlan0
> > wlan0     IEEE 802.11abg  ESSID:off/any  
> >           Mode:Managed  Access Point: Not-Associated   Tx-Power=15 dBm   
> >           Retry short limit:7   RTS thr:off   Fragment thr:off
> >           Encryption key:off
> >           Power Management:on
> >           
> > root@duo:~# iw dev wlan0 get power_save
> > Power save: on
> > root@duo:~# 
> 
> Could you confirm that problem happen with power save on and do not
> happen without it ?

It has not happened for a while, but I was not loading wifi as
heavily.

But even powersave=on case needs to be fixed, right?
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
