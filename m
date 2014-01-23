Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755495AbaAWT3p (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jan 2014 14:29:45 -0500
Received: from mail.skyhub.de ([78.46.96.112]:45957 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752137AbaAWT3n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jan 2014 14:29:43 -0500
Date: Thu, 23 Jan 2014 20:29:39 +0100
From: Borislav Petkov <bp@alien8.de>
To: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@kernel.org>
Subject: Re: AMD microcode loading broken on 32 bit
Message-ID: <20140123192939.GB11190@pd.tnic>
References: <52DE94A9.9060505@oracle.com>
 <20140121161438.GD9004@pd.tnic>
 <52DEB4A9.4070707@oracle.com>
 <20140121182554.GE9004@pd.tnic>
 <52E15AAE.4090106@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <52E15AAE.4090106@oracle.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 23, 2014 at 01:08:46PM -0500, Boris Ostrovsky wrote:
> So I tried this on a "good" system and I am pretty sure this is
> broken. I don't have any microcode in initrd and I am still dying in
> load_microcode_amd().

32-bit still or 64-bit?

> I didn't dig any further but if you can't reproduce this I can look at
> what is a NULL and why. (I suspect it's the 'container' variable).

I will have a look soon - currently busy with other stuff.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
