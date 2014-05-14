Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753550AbaENJ3Z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 05:29:25 -0400
Received: from mout.kundenserver.de ([212.227.126.130]:58892 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751055AbaENJ3V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 05:29:21 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: linux-arm-kernel@lists.infradead.org,
        Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [RESEND] ARM: remove last use of CONFIG_CPU_ARM710
Date: Wed, 14 May 2014 11:28:50 +0200
Message-ID: <4305975.PvMXZQ020k@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.11.0-18-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1400059550.31197.12.camel@x220>
References: <1364507176.1345.45.camel@x61.thuisdomein> <8309592.drxAj71PnZ@wuerfel> <1400059550.31197.12.camel@x220>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:ocoF5D9tC4XDF88EymEK9AIXpOJ8Pd//OPo+G7yXwdq
 cvtHJoYLwrlkEPLcc/cdfNdtXX3aYCrNt8ncfBqYjngf5mjUAO
 z2msGVheTstsTOpvAL1TLctjPihMtMk6mHOcLk0Vh9Lrl0n3Ii
 29B+caVBzPwPXniyNu4WdquDUK6HSnKfuHEA9BzPVRqLD6HLlv
 r0kAPHBFJ1+T691BEw//bDRowvG0Blaz0npUKMZM52fcui7oOS
 AY8lb1Kd1fXyjW+9Wy6xKEUWZoj20Gq2v8xl5/04FROk9cEesw
 YMI4uCbas7+sDxNZ1IFa0RSffFKFzzbyk1xW6Nzvq2+TM/twUZ
 Rk+Q70JaeJb1C7wvQG+w=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 14 May 2014 11:25:50 Paul Bolle wrote:
> On Wed, 2014-05-14 at 11:17 +0200, Arnd Bergmann wrote:
> > 'git grep -i arm710' tells me that there is also some arm710
> > specific code in  arch/arm/mm/proc-arm720.S that we may want to
> > remove along with this.
> > 
> > The DT binding should probably remain untouched though, I think it's
> > correct to document the string.
> 
> That seems to be cpu_arm710_name, __arm710_setup, and everything called
> by __arm710_setup. Cleaning that up (as a separate patch) appears to be
> trivial. If I do that it would be (sort of educated) guesswork. But I
> don't mind doing it. What do you prefer?

I think that would be great. For the first patch, please add 

Acked-by: Arnd Bergmann <arnd@arndb.de>

Once the second patch is reviewed, please add them both to Russell's
patch tracker.

	Arnd
