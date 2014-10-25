Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752212AbaJYSuD (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Oct 2014 14:50:03 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:53592 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752161AbaJYSt7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Oct 2014 14:49:59 -0400
Date: Sat, 25 Oct 2014 13:42:46 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>,
        kernel list <linux-kernel@vger.kernel.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "Berg, Johannes" <johannes.berg@intel.com>,
        "ilw@linux.intel.com" <ilw@linux.intel.com>
Subject: Re: 3.18-rc0: iwlegacy failed after a while
Message-ID: <20141025114246.GA16230@amd>
References: <0BA3FCBA62E2DC44AF3030971E174FB31B552E3F@hasmsx107.ger.corp.intel.com>
 <20141024121240.GA3177@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141024121240.GA3177@redhat.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 2014-10-24 14:12:40, Stanislaw Gruszka wrote:
> On Thu, Oct 23, 2014 at 01:02:37PM +0000, Grumbach, Emmanuel wrote:
> > [Changed subject]
> > This is really iwlegacy and not iwlwifi.
> > 
> > 
> > > 
> > > Hi!
> > > 
> > > Full dmesg is in the attachment, I guess the troubles started with:
> > > 
> > > iwl3945 0000:03:00.0: Queue 4 stuck for 2004 ms.
> > > iwl3945 0000:03:00.0: On demand firmware reload
> > > iwl3945 0000:03:00.0: Master Disable Timed Out, 100 usec
> > > ieee80211 phy0: Hardware restart was requested
> > > iwl3945 0000:03:00.0: BSM uCode verification failed at addr
> > > 0x00003800+0 (of 900), is 0xa5\
> > > a5a5a2, s/b 0xf802020
> > > iwl3945 0000:03:00.0: Unable to set up bootstrap uCode: -5
> > > 
> > 
> > Huh - I don't remember any change there, but you should ask the right person - iwlegacy maintainer :)
> 
> Since 3.17 we have only 2 minor iwlegacy changes on current linus tree.
> If this is a regression it's probably caused by different subsystem
> changes, most likely by PCI changes. If this is not regression, such
> errors could be caused by enabling PS, but that has to be done
> explicitly, Pavel did you enable power_save ? 

This is running pretty standart MATE desktop, and no, I don't think I
enabled that.
									Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
