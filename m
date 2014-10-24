Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756524AbaJXMPS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2014 08:15:18 -0400
Received: from mx1.redhat.com ([209.132.183.28]:53330 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756090AbaJXMPQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2014 08:15:16 -0400
Date: Fri, 24 Oct 2014 14:12:40 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>
Cc: Pavel Machek <pavel@ucw.cz>, kernel list <linux-kernel@vger.kernel.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "Berg, Johannes" <johannes.berg@intel.com>,
        "ilw@linux.intel.com" <ilw@linux.intel.com>
Subject: Re: 3.18-rc0: iwlegacy failed after a while
Message-ID: <20141024121240.GA3177@redhat.com>
References: <0BA3FCBA62E2DC44AF3030971E174FB31B552E3F@hasmsx107.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0BA3FCBA62E2DC44AF3030971E174FB31B552E3F@hasmsx107.ger.corp.intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 23, 2014 at 01:02:37PM +0000, Grumbach, Emmanuel wrote:
> [Changed subject]
> This is really iwlegacy and not iwlwifi.
> 
> 
> > 
> > Hi!
> > 
> > Full dmesg is in the attachment, I guess the troubles started with:
> > 
> > iwl3945 0000:03:00.0: Queue 4 stuck for 2004 ms.
> > iwl3945 0000:03:00.0: On demand firmware reload
> > iwl3945 0000:03:00.0: Master Disable Timed Out, 100 usec
> > ieee80211 phy0: Hardware restart was requested
> > iwl3945 0000:03:00.0: BSM uCode verification failed at addr
> > 0x00003800+0 (of 900), is 0xa5\
> > a5a5a2, s/b 0xf802020
> > iwl3945 0000:03:00.0: Unable to set up bootstrap uCode: -5
> > 
> > Best regards,
> > 								Pavel
> > 
> > --
> 
> Huh - I don't remember any change there, but you should ask the right person - iwlegacy maintainer :)

Since 3.17 we have only 2 minor iwlegacy changes on current linus tree.
If this is a regression it's probably caused by different subsystem
changes, most likely by PCI changes. If this is not regression, such
errors could be caused by enabling PS, but that has to be done
explicitly, Pavel did you enable power_save ? 

Stanislaw
