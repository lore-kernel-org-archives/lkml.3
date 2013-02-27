Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932322Ab3B0L1S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2013 06:27:18 -0500
Received: from h1446028.stratoserver.net ([85.214.92.142]:42084 "EHLO
	mail.ahsoftware.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756450Ab3B0L1R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2013 06:27:17 -0500
Message-ID: <512DED86.4060207@ahsoftware.de>
Date: Wed, 27 Feb 2013 12:27:02 +0100
From: Alexander Holler <holler@ahsoftware.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130219 Thunderbird/17.0.3
MIME-Version: 1.0
To: James Courtier-Dutton <james.dutton@gmail.com>
CC: ownssh <ownssh@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL] Load keys from signed PE binaries
References: <87ppzo79in.fsf@mid.deneb.enyo.de> <30665.1361461678@warthog.procyon.org.uk> <CA+55aFxyuvC1H6doSw_e_yLTey2YGWU9cLnUzxUeT2kaeazydA@mail.gmail.com> <20130221164244.GA19625@srcf.ucam.org> <18738.1361836265@warthog.procyon.org.uk> <loom.20130227T103444-514@post.gmane.org> <CAAMvbhFgNC7fXE2KrDC+aq+Q1dsS7pESvtCrCcMyzJksvARyQQ@mail.gmail.com>
In-Reply-To: <CAAMvbhFgNC7fXE2KrDC+aq+Q1dsS7pESvtCrCcMyzJksvARyQQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 27.02.2013 11:17, schrieb James Courtier-Dutton:

> 3) Trust based on date. I trust everything from X that I put on my
> system 2 weeks ago, but one week ago X got hacked, so don't trust
> anything new from them until the hack has been stopped and the
> revokation/correction steps have been completed.
> E.g. the Bit9 case, where malware was able to be signed.

Which date? In reality dates are (mostly) defined as fixed points, but 
computers just don't have such.

E.g. currently you can't use modsign based on X.509 certificates if the 
date comes through USB, because modsign tries to load the certificate 
before before the USB stack comes up, which ends up with invalid dates 
(Not Before).
And changing the system date isn't that hard for an attacker if he is 
already able to do other bad things.

Regards,

Alexander

