Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758067Ab3KOK4q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Nov 2013 05:56:46 -0500
Received: from mail.southpole.se ([37.247.8.11]:45765 "EHLO mail.southpole.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753494Ab3KOK4l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Nov 2013 05:56:41 -0500
Message-ID: <5285FE1D.3020800@southpole.se>
Date: Fri, 15 Nov 2013 11:57:33 +0100
From: Jonas Bonn <jonas@southpole.se>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130404 Thunderbird/17.0.5
MIME-Version: 1.0
To: Geert Uytterhoeven <geert@linux-m68k.org>
CC: linux@openrisc.net,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Kevin Mehall <contact@kevinmehall.net>,
        Marek Czerski <ma.czerski@gmail.com>,
        Stefan Kristiansson <stefan.kristiansson@saunalahti.fi>
Subject: Re: [PATCH] openrisc: Add DTS and defconfig for DE0-Nano
References: <1384029451-16555-1-git-send-email-geert@linux-m68k.org> <5285EE5A.1070202@southpole.se> <CAMuHMdWA-9ax=NG_d0tyfzY3+42Ka7_r+jTeF-m5oW0eV8t1=g@mail.gmail.com>
In-Reply-To: <CAMuHMdWA-9ax=NG_d0tyfzY3+42Ka7_r+jTeF-m5oW0eV8t1=g@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Assp-Version: 2.3.3(13276) on assp.southpole.se
X-Assp-ID: assp.southpole.se 12998-02349
X-Assp-Session: 7F739AB3DDD0 (mail 1)
X-Assp-Client-TLS: yes
X-Assp-Server-TLS: yes
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/15/2013 11:22 AM, Geert Uytterhoeven wrote:
>> This should probably be "altera,de0_nano".  We also need to put a version
>
> "terasic,de0_nano"? The board says "Designed and manufactured by Terasic".
> Hmm, the sticker on the box says "Altera DE0-Nano".

Good question...

>>
>> Version number needed.  OpenCores wanted "projectname-rtlsvn###" where ###
>> is the SVN commit number of the RTL directory in the project's source
>> repository.
>
> That's gonna need some information diving, as Stefan's orpsoc git repositories
> only contains references to orpsocv2 git-svn-ids, not the svn ids of
> the original
> component repositories.

Stefan?  Where's the "official" home of these cores nowadays?  Have they 
been modified since they were copied from OpenCores into orpsocv2?

>> Like I mentioned earlier, I'd like to see this thing disappear altogether
>> and be replaced with gpio-generic.
>
> That needs device-tree support and published bindings first. IIRC, you
> had some preliminary code?

I thought I did, but I was mistaken.  I don't have anything for 
gpio-generic.

/Jonas
