Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751277Ab3HTKYP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 06:24:15 -0400
Received: from mail-ob0-f182.google.com ([209.85.214.182]:42213 "EHLO
	mail-ob0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750927Ab3HTKYO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 06:24:14 -0400
Date: Tue, 20 Aug 2013 03:24:59 -0500
From: Rob Landley <rob@landley.net>
Subject: Re: Kernel summit 2013: Call for Hobbyists
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Francois Romieu <romieu@fr.zoreil.com>, "Theodore Ts'o" <tytso@thunk.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        ksummit-2013-discuss@lists.linuxfoundation.org
In-Reply-To: <CAMuHMdXeQXUZ0pt1tb3Ch8j6mmqz9AiGirmjcp=a2ZDXX6VqtA@mail.gmail.com>
	(from geert@linux-m68k.org on Sun Aug 18 03:26:03 2013)
X-Mailer: Balsa 2.4.11
Message-Id: <1376987099.2737.63@driftwood>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; DelSp=Yes; Format=Flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/18/2013 03:26:03 AM, Geert Uytterhoeven wrote:
> On Fri, Aug 16, 2013 at 11:02 PM, Francois Romieu  
> <romieu@fr.zoreil.com> wrote:
> > As a hobbyist, I have less time than most pro and must cope with
> > whatever brain juice remains after the paid work. It doesn't make me
> 
> Indeed. And the dosing of brain juice is not always aligned with the  
> steady
> pace of Linux kernel development, causing hobyists to miss merge  
> windows,
> resubmissions, and general follow-up.

And those of us who don't have "follow linux-kernel" as part of a day  
job's responsibilities tend to be several days behind, so it's hard to  
participate in coversations.

I seldom get paid to work on a current kernel. I _have_ been paid to  
beat some horrible vendor board support package with a rock until it  
sticks to the hardware, but this is invariably multiple years behind  
current and has a lineage like "vanilla kernel, forked by android for  
ice cream sandwich, then forked by TI's Netra Board Support Package,  
then forked by Polycom because implementing Skype in hardware seemed  
like a good idea at the time". (My last contract involved Centos 6.3, a  
fresh release with a 4 year old kernel. Lots of backporting stuff from  
~3.4 to 2.6.32 or whatever it was using. Because that's when what I  
needed was feature complete and there were fewer API changes than  
current, that's why.)

I do sometimes get to chip bits off and port them to upstream, after  
the fact, if there's time, and if my boss can shield the effort from  
every legal department's ironclad desire to do the absolute minimum  
required and no more. Usually there's just a nominal source tarball  
snapshot (no source control history, that's confidential) posted to  
some obscure website when the hardware finally ships (and the dev  
team's broken up), and if you _do_ diff this obsolete thing against  
vanilla the diff is multiple megabytes and most of it wasn't our  
changes.

Intermittently getting paid to do that means I _don't_ qualify as a  
hobbyist, apparently. Even though the vast majority of actual open  
soruce programming I get done is in the downtime _between_ contracts.

(I'm listed in MAINTAINERS for trying to prevent documentation from  
falling through the cracks when nobody else merges it through their  
tree. I got paid to work on Linux documentation once, for a very nice 6  
months back in 2007, but I didn't get listed in MAINTAINERS until ~3  
years after that stopped.)

Rob