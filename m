Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752483Ab3KQUGa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Nov 2013 15:06:30 -0500
Received: from mail.skyhub.de ([78.46.96.112]:60491 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751906Ab3KQUGT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Nov 2013 15:06:19 -0500
Date: Sun, 17 Nov 2013 21:05:46 +0100
From: Borislav Petkov <bp@alien8.de>
To: "MPhil. Emanoil Kotsev" <Emanoil.Kotsev@fincom.at>
Cc: intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        Daniel Vetter <daniel@ffwll.ch>
Subject: Re: [Intel-gfx] kernel 3.11.6 general protection fault
Message-ID: <20131117200546.GP27323@pd.tnic>
References: <201311132058.30310.Emanoil.Kotsev@fincom.at>
 <201311171545.35217.Emanoil.Kotsev@fincom.at>
 <20131117150607.GF27323@pd.tnic>
 <201311171745.19339.Emanoil.Kotsev@fincom.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <201311171745.19339.Emanoil.Kotsev@fincom.at>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 17, 2013 at 05:45:18PM +0100, MPhil. Emanoil Kotsev wrote:
> How - new libraries - more exhaustive algorythms - higher cpu usage
> etc. Some of the things M$ is doing on purpose to force you upgrade
> your hardware every 2-3years

That would be too easy and machines would be dying left and right of
overheating. Actually, sane hardware is much more robust than that and
it throttles itself in case of critical temperature levels. And, IMHO
your Dell Latitude D520 should be fine, in that respect. But we'll see.
:-)

> I wanted to first compile the kernel with the debug option you
> mentioned, but while compiling it went to about 75°C.

Yeah, that's still ok if we trust the output saying that 126°C is the
critical temp.

It would be interesting to see what this sensor says right before the
machine locks up.

HTH.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
