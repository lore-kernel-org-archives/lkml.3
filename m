Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755686AbaA1Uw6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jan 2014 15:52:58 -0500
Received: from mail.skyhub.de ([78.46.96.112]:36492 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755212AbaA1Uw4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jan 2014 15:52:56 -0500
Date: Tue, 28 Jan 2014 21:52:46 +0100
From: Borislav Petkov <bp@alien8.de>
To: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@kernel.org>
Subject: Re: AMD microcode loading broken on 32 bit
Message-ID: <20140128205246.GL815@pd.tnic>
References: <52DE94A9.9060505@oracle.com>
 <20140121161438.GD9004@pd.tnic>
 <52DEB4A9.4070707@oracle.com>
 <20140121182554.GE9004@pd.tnic>
 <52E15AAE.4090106@oracle.com>
 <20140123192939.GB11190@pd.tnic>
 <52E17087.2060301@oracle.com>
 <20140128162431.GH815@pd.tnic>
 <52E8168D.9060805@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <52E8168D.9060805@oracle.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 28, 2014 at 03:43:57PM -0500, Boris Ostrovsky wrote:
> It fixes the case when there is no microcode in initrd but when
> microcode is corrupted (as was the case when we were pointing to Intel
> binary) we still die. Neither container nor ucode_cpio.data is NULL in
> this case.

How is that possible? Did you generate a path in the cpio by the name of

"kernel/x86/microcode/AuthenticAMD.bin"

but with Intel microcode in it?

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
