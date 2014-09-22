Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754684AbaIVT5o (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 15:57:44 -0400
Received: from mail.skyhub.de ([78.46.96.112]:46805 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750914AbaIVT5n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 15:57:43 -0400
Date: Mon, 22 Sep 2014 21:57:37 +0200
From: Borislav Petkov <bp@alien8.de>
To: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Cc: "Rustad, Mark D" <mark.d.rustad@intel.com>,
        "sparse@chrisli.org" <sparse@chrisli.org>,
        "linux-sparse@vger.kernel.org" <linux-sparse@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/7] Silence even more W=2 warnings
Message-ID: <20140922195737.GE4709@pd.tnic>
References: <1411140580-20909-1-git-send-email-jeffrey.t.kirsher@intel.com>
 <20140922153355.GB4510@pd.tnic>
 <AEF1C0F7-239C-436B-97A5-6AFF49FD9359@intel.com>
 <20140922184049.GB4709@pd.tnic>
 <3199350A-89CE-4BE7-8FE4-CA8CE4F87622@intel.com>
 <20140922192152.GD4709@pd.tnic>
 <1411415057.2513.8.camel@jtkirshe-mobl.jf.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1411415057.2513.8.camel@jtkirshe-mobl.jf.intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 22, 2014 at 12:44:17PM -0700, Jeff Kirsher wrote:
> Not sure you showed us, since that is how everyone has had to do to
> actual find W= builds useful.  Just because that is how we HAVE to do it
> now, does not make it the best way.  Here is a thought, we don't we fix
> the potential issues, so that W= builds do not generate over 100,000
> errors/warnings.
> 
> Mark did this approach because it would either spur the conversation
> that this is a good idea OR let's fix the root problem.  Instead it
> sounds like your response is "life sucks, get over it" and put your head
> back in the sand to ignore the problem.

Hey hey, relax a little - no need to get offensive all of a sudden.

Having to grep through a log file full of gcc warnings is a much better
thing to do IMNSVHO than adding code to the kernel just to shut up the
compiler. We had huge discussions even about something as silly as
uninitialized_var() which was supposed to shut up the compiler but ended
up actively causing bugs.

Now, you're arguing for adding obscure macros to shut up warnings which
are disabled in the first place because you don't want to grep through
log files.

If you can't see the absurdity of your proposal then maybe we should
agree to disagree and declare this back-and-forth for having run its
course. In any case, you get my NAK for it.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
