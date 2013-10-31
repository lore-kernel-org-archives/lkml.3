Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754554Ab3JaQoN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Oct 2013 12:44:13 -0400
Received: from mail.skyhub.de ([78.46.96.112]:57655 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751621Ab3JaQoL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Oct 2013 12:44:11 -0400
Date: Thu, 31 Oct 2013 17:44:03 +0100
From: Borislav Petkov <bp@alien8.de>
To: emanoil.kotsev@fincom.at
Cc: linux-kernel@vger.kernel.org, intel-gfx@lists.freedesktop.org
Subject: Re: kernel 3.11.6 general protection fault
Message-ID: <20131031164403.GG10544@pd.tnic>
References: <e09ad4cb88b923ec017a516e6778b6bd@fincom.at>
 <20131031143711.GA9818@pd.tnic>
 <cfb4b5e820828e60ad24be359b6e574b@fincom.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <cfb4b5e820828e60ad24be359b6e574b@fincom.at>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please do not top-post.

On Thu, Oct 31, 2013 at 04:52:54PM +0100, emanoil.kotsev@fincom.at wrote:
> Hi, thanks for swift response.
> Yes, without those modules loaded it hangs as well. Perhaps I did
> not understand you well - do you mean unloaded or not
> compiled/installed, or even blacklisted. I tried only with unloading
> them.

Right, try to build a kernel from pristine 3.11.6 sources without any
vmware code patched in or loaded. To be sure, get the sources anew so
that you don't have any remnants of those modules and build the whole
thing from scratch.

AFAIK, those vendor packages have some hooks into the kernel
installation path so make sure you remove those vmware packages too with
your distro's package manager or however they are being removed.

> The custom stuff is vmware nothing else, but if I remember issues
> popped up after compiling/patching vmware/player for 3.10 As I said
> I noticed this recently when I spent more time watching youtube
> videos, but it could be that this only reveals the problem which was
> persistent before (perhaps after vmplayer patch/modules).

Yeah, from the looks of it, it probably would happen if you do other
things too.

> I'm using the Notebook with a docking station - and I have a same
> notebook with different bios version. Does it make sense to try the
> kernel on a different bios version?

Well, since you started seeing this after patching 3.10, I don't think
the BIOS was the problem so no need to do any BIOS updates for now.

HTH.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
