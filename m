Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751927AbbAUMsF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 07:48:05 -0500
Received: from cantor2.suse.de ([195.135.220.15]:52366 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750754AbbAUMsA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 07:48:00 -0500
Date: Wed, 21 Jan 2015 13:47:58 +0100
From: Borislav Petkov <bp@suse.de>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: x86-ml <x86@kernel.org>, lkml <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] x86 cleanups for 3.20
Message-ID: <20150121124757.GA31527@pd.tnic>
References: <20150113141255.GB5784@pd.tnic>
 <alpine.DEB.2.11.1501201340421.5526@nanos>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.11.1501201340421.5526@nanos>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 20, 2015 at 01:42:33PM +0100, Thomas Gleixner wrote:
> This one is equally pointless as the other two which remove a few more
> defines. Can you please zap that and resend the pull request?

So basically those two only:

http://git.kernel.org/cgit/linux/kernel/git/bp/bp.git/commit/?id=60b217a03b1156a22926ec0770c2aa08679ea769
http://git.kernel.org/cgit/linux/kernel/git/bp/bp.git/commit/?id=f94fe119f2e53362a3038ee856fa58412f728bc9

Want me to resend or you can simply cherry-pick them?

Thanks.

-- 
Regards/Gruss,
    Boris.

ECO tip #101: Trim your mails when you reply.
--
