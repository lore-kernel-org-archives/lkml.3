Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932116Ab3HMUAb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 16:00:31 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:22089 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932084Ab3HMUA2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 16:00:28 -0400
X-Authority-Analysis: v=2.0 cv=P6i4d18u c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=-lix0HmpxE0A:10 a=5SG0PmZfjMsA:10 a=kj9zAlcOel0A:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=GP9tColRbicA:10 a=DfNHnWVPAAAA:8 a=SLXlyDuLFlUODyGR00MA:9 a=CjuIK1q_8ugA:10 a=lBRciGGoxdUA:10 a=jeBq3FmKZ4MA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Date: Tue, 13 Aug 2013 16:00:25 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Luis Henriques <luis.henriques@canonical.com>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Christian Lamparter <chunkeey@googlemail.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: Re: [05/88] carl9170: fix frame drop and WARN due to minstrel_ht
 change
Message-ID: <20130813160025.2a45efbe@gandalf.local.home>
In-Reply-To: <877gfp4imn.fsf@canonical.com>
References: <20130813155654.069291373@goodmis.org>
	<20130813155824.466423327@goodmis.org>
	<877gfp4imn.fsf@canonical.com>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 13 Aug 2013 18:15:28 +0100
Luis Henriques <luis.henriques@canonical.com> wrote:

> Steven Rostedt <rostedt@goodmis.org> writes:
> 
> > 3.6.11.7-rc1 stable review patch.
> > If anyone has any objections, please let me know.
> 
> Not exactly an objection, but the commit text refers to:
> 
>  a0497f9 mac80211/minstrel_ht: add support for using CCK rates
> 
> which doesn't seem to exist in 3.6 kernel.  I wonder if this commit is
> actually needed.

No it doesn't :-/

Grumble, it would be nice if people added which kernel a patch goes to.
I started out looking at over 200 commits to determine which should be
backported or not. I look for any stable tags first, and then read the
commit log for SHA1s that I can look for. It seems that I missed that
this commit did state which commit caused the issue, it must have
applied fine, because failed applied patches I scrutinize even more.

Oh well, I'll nuke this commit.

Thanks!

-- Steve
