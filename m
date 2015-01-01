Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751620AbbAAT0Q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jan 2015 14:26:16 -0500
Received: from plane.gmane.org ([80.91.229.3]:37373 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751007AbbAAT0P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jan 2015 14:26:15 -0500
X-Injected-Via-Gmane: http://gmane.org/
Mail-Followup-To: linux-kernel@vger.kernel.org
To: linux-kernel@vger.kernel.org
From: rh_ <richard_hubbe11@lavabit.com>
Subject: Re: apparent loss of continuity in kernel .config?
Date: Thu, 1 Jan 2015 11:24:24 -0800
Organization: L2N
Message-ID: <20150101112424.2accee4e@127>
References: <201412310916.57808.gheskett@wdtv.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: ip68-6-109-86.sb.sd.cox.net
User-Agent: dsodnetnin
X-Gmane-NNTP-Posting-Host: EZnn0.37p
Original-Received: from slem by 1.1 with local
X-No-Archive: yes
Archive: no
X-Archive: encrypt
X-Operating-System: Barebones_6.1
X-Gmane-NNTP-Posting-Host: 192.168.1.1
X-NNTP-Posting-Host: 192.168.1.1
Mail-Copies-To: never
X-Archive: expiry=79
X-Mailer: EZnn0.37u
X-Newsreader: EZnn0.37u
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 31 Dec 2014 09:16:57 -0500
Gene Heskett <gheskett@wdtv.com> wrote:

> Greetings;
> 
> Usually, when I build a new kernel, just placing a copy of an older 
> versions .config in the unpacked src directory is sufficient that
> only what has been changed has to be answered during a make
> oldconfig, perhaps a couple dozen new features need to be answered
> yes or no, and I have a .config that will usually build me a bootable
> kernel.  Not any more.
> 
> Since my 3.16.0 has been suffering from stalls of up to 2 or 3
> minutes while both htop and gkrellm continue to report that there is
> nothing hogging the machine, in a general description that matches
> the Dave Jone saga, but w/o the log spew, probably because I don't
> have extreme debugging enabled.
> 
> But its strange in how it manifests itself as it will do it from a
> fresh boot, and I get aggravated and reboot, and it doesn't do it
> till the next reboot which may be a month later.  Almost an alternate
> boot phenomenon. 
> Attempting to go from 3.16.0 to 3.16.7 last night, a make oldconfig 
> started from scratch as if there were no .config's in the directory.
> I stood on the enter key to take the defaults, then ran a make
> xconfig to discover it was totally wrong for an AMD phenom, no
> networking, no disc drivers, video was an old ATI, when there is an
> nvidia card in it, yadda, yadda.
> 
> I went thru this exercise 4 times, as I keep a gzipped copy on the
> config that built the kernel version in the boot directory with my
> build script. And every time it was the same story.
> 
> Obviously I can't, at 80 yo, remember every item in a 28k .config
> file from build to build, so what am I doing wrong that is destroying
> this continuity?
> 
> Thanks everybody.

Have you had any replies?  I do similar but I may be less patient
than you. I keep dragging around my previous .config and when it
no longer works I just stay with the kernel that's working. And try
again later. It's been interesting to see what new things default
to "yes" along the way.

I would not call it "loss of continuity", I would call it loss of
backward compatibility. If the kernel breaks userspace it causes
a shitstorm but if the kernel breaks the kernel buildspace you're
supposed to suck it up and make a new .config from scratch.


> "There are four boxes to be used in defense of liberty:
>  soap, ballot, jury, and ammo. Please use in that order."
> -Ed Howdershelt (Author)
> Genes Web page <http://geneslinuxbox.net:6309/gene>
> US V Castleman, SCOTUS, Mar 2014 is grounds for Impeaching SCOTUS

Since voting machines,SCOTUS and juries have been compromised it
seems we're down to that last box.





