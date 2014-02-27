Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754315AbaB0B5V (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 20:57:21 -0500
Received: from mail.wdtv.com ([66.118.69.84]:53952 "EHLO mail.wdtv.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753524AbaB0B5U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 20:57:20 -0500
From: Gene Heskett <gheskett@wdtv.com>
To: Ken Moffat <zarniwhoop@ntlworld.com>
Subject: Re: 3.13.5 : rm -rf running forever, one cpu at approx 100%
Date: Wed, 26 Feb 2014 20:57:19 -0500
Cc: linux-kernel@vger.kernel.org
References: <20140227005246.GB10367@milliways> <201402262028.29352.gheskett@wdtv.com> <20140227014744.GA12070@milliways>
In-Reply-To: <20140227014744.GA12070@milliways>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="windows-1256"
Content-Transfer-Encoding: 8bit
Message-Id: <201402262057.19111.gheskett@wdtv.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 26 February 2014, Ken Moffat wrote:
>On Wed, Feb 26, 2014 at 08:28:29PM -0500, Gene Heskett wrote:
>> On Wednesday 26 February 2014, Ken Moffat wrote:
>> 
>> I don't have any help to offer Ken, but this walks and quacks much like
>> a duck I'm encountering in 3.13.5, with the backup program amanda,
>> which uses gnu tar.  To facilitate intelligent guesses as to the size
>> of the various levels of backup, amanda does a dummy collection using
>> tar, sent to /dev/null, using only the size it reports on the first
>> pass.  Version 1.22, quite old, works on 3.12.9, but not on 3.13.5.  I
>> have now pulled in, built and installed tar-1.27, and rebuilt amanda
>> to let it know that the tar its using is not in /usr/bin, but in
>> /usr/local/bin.  Next run at 1:30AM
>> 
>> This freeze, using 100% of a core, but causing no visible disk activity
>> has killed my backups 3 nights running.  At this point I've no clue as
>> to the cause, but I will be watching this thread closely, it has a
>> similar description.
>> 
>> Cheers, Gene
>
> My box where I see this is a phenom (my intel is still on 3.13.4),
>and from past threads I suspect yours is as well ?
>
>ĸen

Yes, it is Ken, an old slow 2.1 Ghz 9550 phenom, with 8Gb of ram. 32 bit 
PAE build.  I wonder if that is also connected...  But my crystal ball is 
broke, in addition to the wet ram  starting to rust out.  Can't be the 
years, I've only 40 years practice at being 39. ;-)

Cheers, Gene
-- 
"There are four boxes to be used in defense of liberty:
 soap, ballot, jury, and ammo. Please use in that order."
-Ed Howdershelt (Author)
Genes Web page <http://geneslinuxbox.net:6309/gene>

NOTICE: Will pay 100 USD for an HP-4815A defective but
complete probe assembly.

