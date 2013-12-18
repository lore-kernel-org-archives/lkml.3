Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752002Ab3LRU7e (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 15:59:34 -0500
Received: from nebula.mojo.cc ([46.4.89.19]:46071 "EHLO nebula.mojo.cc"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750910Ab3LRU7c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 15:59:32 -0500
From: "MPhil. Emanoil Kotsev" <Emanoil.Kotsev@fincom.at>
Organization: FinCom Consulting
To: Borislav Petkov <bp@alien8.de>
Subject: Re: [Intel-gfx] kernel 3.11.6 general protection fault
Date: Wed, 18 Dec 2013 21:59:22 +0100
User-Agent: KMail/1.9.10 (enterprise35 0.20100827.1168748)
Cc: intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        Daniel Vetter <daniel@ffwll.ch>
References: <201311132058.30310.Emanoil.Kotsev@fincom.at> <201311171745.19339.Emanoil.Kotsev@fincom.at> <20131117200546.GP27323@pd.tnic>
In-Reply-To: <20131117200546.GP27323@pd.tnic>
X-KMail-QuotePrefix: > 
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201312182159.22794.Emanoil.Kotsev@fincom.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi again,
sorry for writing  after such long time of silence, but I was busy with one 
project (and family as well)

On Sunday 17 November 2013 21:05:46 you wrote:
> On Sun, Nov 17, 2013 at 05:45:18PM +0100, MPhil. Emanoil Kotsev wrote:
> > How - new libraries - more exhaustive algorythms - higher cpu usage
> > etc. Some of the things M$ is doing on purpose to force you upgrade
> > your hardware every 2-3years
>
> That would be too easy and machines would be dying left and right of
> overheating. Actually, sane hardware is much more robust than that and
> it throttles itself in case of critical temperature levels. And, IMHO
> your Dell Latitude D520 should be fine, in that respect. But we'll see.
>

I was able to solve the issue by removing some of the modules I had in 
xorg.conf.
I noticed that it is not the cpu that is overheating, but rather the 
video/graphic card. The area around the "Dell" logo on the front of the 
display is still pretty hot, but the system seem to be working fine now and I 
can not reproduce the issue any more.
Someone would ask why I'm using the xorg.conf. The reason is because without 
it X automatically loads the GL direver for 3d support and I am not able to 
use second display.
Perhaps it is worth trying latest intel driver as susggested before. However 
with the current one it is working fine, so I would consider the issue as 
solved.

I would like to thank you for your precious support and ideas once again.

regards
