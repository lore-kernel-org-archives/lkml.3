Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934401Ab3BMQgA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 11:36:00 -0500
Received: from brent.tribalogic.net ([78.86.109.144]:49996 "EHLO
	brent.tribalogic.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934139Ab3BMQf7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 11:35:59 -0500
X-Greylist: delayed 568 seconds by postgrey-1.27 at vger.kernel.org; Wed, 13 Feb 2013 11:35:59 EST
Message-ID: <511BBEB3.3070607@colin.guthr.ie>
Date: Wed, 13 Feb 2013 16:26:27 +0000
From: Colin Guthrie <gmane@colin.guthr.ie>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130114 Thunderbird/17.0.2
MIME-Version: 1.0
To: Andreas Mohr <andi@lisas.de>
CC: initramfs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [REGRESSION] [nailed] USB boot failure: USB: EHCI: make ehci-pci
 a separate driver
References: <20130213161353.GA17177@rhlx01.hs-esslingen.de>
In-Reply-To: <20130213161353.GA17177@rhlx01.hs-esslingen.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

'Twas brillig, and Andreas Mohr at 13/02/13 16:13 did gyre and gimble:
> [not sure about CCs - I readded both initramfs-tools and lkml]

Sorry about CC's I read mail via gmane's NNTP interface and it mangles
the address for the initramfs list which makes it a pain to reply-all
properly. If someone who manages this stuff could ask a gmane.org admin
to lift the mangling that would be good. There are other places to
harvest the same email addresses if someone really wants to!

>> Either way I already posted a patch about this a while back:
> 
>> See: "[PATCH 6/6] kernel-modules: Add ehci support for kernel 3.8+"
> 
> OK, I've seen it, but:
> which file does it touch?? That's a complete mystery to me
> (the initramfs-tools git checkout here does not contain that path).

Oh, oops, my bad sorry. I didn't read your mail properly and didn't see
the initramfs-tools bit. The patch is against dracut, so obviously won't
apply nicely :D

Sorry for the confusion.

Col

-- 

Colin Guthrie
gmane(at)colin.guthr.ie
http://colin.guthr.ie/

Day Job:
  Tribalogic Limited http://www.tribalogic.net/
Open Source:
  Mageia Contributor http://www.mageia.org/
  PulseAudio Hacker http://www.pulseaudio.org/
  Trac Hacker http://trac.edgewall.org/
