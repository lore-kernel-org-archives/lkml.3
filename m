Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755091Ab3LRVWo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 16:22:44 -0500
Received: from mail.skyhub.de ([78.46.96.112]:54139 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754929Ab3LRVWl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 16:22:41 -0500
Date: Wed, 18 Dec 2013 22:22:33 +0100
From: Borislav Petkov <bp@alien8.de>
To: "MPhil. Emanoil Kotsev" <Emanoil.Kotsev@fincom.at>
Cc: intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        Daniel Vetter <daniel@ffwll.ch>
Subject: Re: [Intel-gfx] kernel 3.11.6 general protection fault
Message-ID: <20131218212233.GE12222@pd.tnic>
References: <201311132058.30310.Emanoil.Kotsev@fincom.at>
 <201311171745.19339.Emanoil.Kotsev@fincom.at>
 <20131117200546.GP27323@pd.tnic>
 <201312182159.22794.Emanoil.Kotsev@fincom.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <201312182159.22794.Emanoil.Kotsev@fincom.at>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 18, 2013 at 09:59:22PM +0100, MPhil. Emanoil Kotsev wrote:
> I was able to solve the issue by removing some of the modules I had in
> xorg.conf. I noticed that it is not the cpu that is overheating, but
> rather the video/graphic card. The area around the "Dell" logo on the
> front of the display is still pretty hot, but the system seem to be
> working fine now and I can not reproduce the issue any more.

Interesting. Which module was that?

It was probably making your GPU go nuts. The more interesting question
is whether this module would behave on your machine normally and only
some buggy incarnation of it would cause the overheating... I.e., it
could be you upgraded X and with the new version the issue started
appearing. Fun.

> I would like to thank you for your precious support and ideas once
> again.

Sure, you're welcome!

:-)

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
