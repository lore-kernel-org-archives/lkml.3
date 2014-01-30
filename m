Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753488AbaA3Ty3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jan 2014 14:54:29 -0500
Received: from mail.skyhub.de ([78.46.96.112]:52297 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751165AbaA3Ty1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jan 2014 14:54:27 -0500
Date: Thu, 30 Jan 2014 20:54:13 +0100
From: Borislav Petkov <bp@alien8.de>
To: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@kernel.org>
Subject: Re: AMD microcode loading broken on 32 bit
Message-ID: <20140130195413.GH23342@pd.tnic>
References: <20140128162431.GH815@pd.tnic>
 <52E8168D.9060805@oracle.com>
 <20140128205246.GL815@pd.tnic>
 <52E81B90.8040604@oracle.com>
 <20140128213030.GM815@pd.tnic>
 <52E8230F.7080300@oracle.com>
 <52E83903.5040908@oracle.com>
 <20140128232219.GO815@pd.tnic>
 <20140130151321.GC23342@pd.tnic>
 <52EAAAD5.2010301@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <52EAAAD5.2010301@oracle.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 30, 2014 at 02:41:09PM -0500, Boris Ostrovsky wrote:
> That's not sufficient though, you'll need the other piece in
> find_ucode_in_initrd() where you check the header.

I meant wrt to looking at ucode_cpio.data. The other piece remains.

> I like this one better. You can move this check above "#ifdef
> CONFIG_X86_32" and have it as the first statement in the routine,
> common between 32- and 64-bit.

Yeah, it is simpler. Ok, will change.

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
