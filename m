Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752265AbaIEXcO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 19:32:14 -0400
Received: from mail-pd0-f171.google.com ([209.85.192.171]:33971 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750910AbaIEXcM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 19:32:12 -0400
Date: Sat, 6 Sep 2014 08:32:03 +0900
From: Tejun Heo <tj@kernel.org>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Wu Zhangjin <falcon@meizu.com>, Takashi Iwai <tiwai@suse.de>,
        Arjan van de Ven <arjan@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Oleg Nesterov <oleg@redhat.com>, hare@suse.com,
        Andrew Morton <akpm@linux-foundation.org>,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        Joseph Salisbury <joseph.salisbury@canonical.com>,
        Benjamin Poirier <bpoirier@suse.de>,
        Santosh Rastapur <santosh@chelsio.com>, Kay Sievers <kay@vrfy.org>,
        One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        Tim Gardner <tim.gardner@canonical.com>,
        Pierre Fersing <pierre-fersing@pierref.org>,
        Nagalakshmi Nandigama <nagalakshmi.nandigama@avagotech.com>,
        Praveen Krishnamoorthy <praveen.krishnamoorthy@avagotech.com>,
        Sreekanth Reddy <sreekanth.reddy@avagotech.com>,
        Abhijit Mahajan <abhijit.mahajan@avagotech.com>,
        Casey Leedom <leedom@chelsio.com>,
        Hariprasad S <hariprasad@chelsio.com>,
        MPT-FusionLinux.pdl@avagotech.com,
        Linux SCSI List <linux-scsi@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [RFC v2 3/6] kthread: warn on kill signal if not OOM
Message-ID: <20140905233203.GG15723@mtj.dyndns.org>
References: <CAB=NE6Wti1RpAFk5q_YeZn2F9Rd=wsiwhyPszu74nG9fXwH5vQ@mail.gmail.com>
 <20140905141241.GC10455@mtj.dyndns.org>
 <20140905164405.GA28964@core.coreip.homeip.net>
 <20140905174925.GA12991@mtj.dyndns.org>
 <20140905181003.GA29003@core.coreip.homeip.net>
 <20140905222956.GA15723@mtj.dyndns.org>
 <20140905223139.GB15723@mtj.dyndns.org>
 <20140905224917.GB35667@core.coreip.homeip.net>
 <20140905225533.GE15723@mtj.dyndns.org>
 <20140905232242.GE35667@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140905232242.GE35667@core.coreip.homeip.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey,

On Fri, Sep 05, 2014 at 04:22:42PM -0700, Dmitry Torokhov wrote:
> > I don't get it.  This is a behavior userland already depends on for
> > boots.  What's there to agree or disagree?  This is just a fact that
> > we can't do this w/o disturbing some userlands in a major way.
> 
> I am just expressing my disbelief that somebody relies on module loading
> being synchronous with probing. Out of curiosity, do you have any
> pointers?

I've seen initrd scripts which depended on the behavior to wait for
storage devices over the years.  AFAIK, none of the modern distros
does it but this has been such a basic feature all along and it seems
highly unlikely to me that there's no userland remaining out there
depending on such behavior.  We do have a lot of different userlands,
many of them quite ad-hoc.

Thanks.

-- 
tejun
