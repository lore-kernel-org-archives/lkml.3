Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752041AbaJEVNM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Oct 2014 17:13:12 -0400
Received: from mail.skyhub.de ([78.46.96.112]:41587 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751943AbaJEVNJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Oct 2014 17:13:09 -0400
Date: Sun, 5 Oct 2014 23:13:04 +0200
From: Borislav Petkov <bp@alien8.de>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: linux-kernel@vger.kernel.org, H Peter Anvin <hpa@zytor.com>
Subject: Re: [PATCH 1/8] x86, microcode, intel: forbid some incorrect metadata
Message-ID: <20141005211304.GA12003@pd.tnic>
References: <1410197875-19252-1-git-send-email-hmh@hmh.eng.br>
 <1410197875-19252-2-git-send-email-hmh@hmh.eng.br>
 <20141005173453.GC9377@pd.tnic>
 <20141005193703.GB24081@khazad-dum.debian.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20141005193703.GB24081@khazad-dum.debian.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 05, 2014 at 04:37:03PM -0300, Henrique de Moraes Holschuh wrote:
> Not realy, because it got you confused! :-)

No, it didn't get me confused - it got you confused that I'm confused.

You need to read the comment as a *whole*. The zero value is special
because it is *used* to *denote* a failure. You can use any other
invalid revision value for that matter.

Maybe "denote" was not precise enough - maybe it should say "0 is an
invalid microcode revision and is used to detect the failure of a
microcode update" or similar. Yeah, "detect" sounds better.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
