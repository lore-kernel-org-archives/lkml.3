Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754765AbaIVUdo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 16:33:44 -0400
Received: from mail.skyhub.de ([78.46.96.112]:33015 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753128AbaIVUdl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 16:33:41 -0400
Date: Mon, 22 Sep 2014 22:33:36 +0200
From: Borislav Petkov <bp@alien8.de>
To: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Cc: "Rustad, Mark D" <mark.d.rustad@intel.com>,
        "sparse@chrisli.org" <sparse@chrisli.org>,
        "linux-sparse@vger.kernel.org" <linux-sparse@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/7] Silence even more W=2 warnings
Message-ID: <20140922203336.GF4709@pd.tnic>
References: <1411140580-20909-1-git-send-email-jeffrey.t.kirsher@intel.com>
 <20140922153355.GB4510@pd.tnic>
 <AEF1C0F7-239C-436B-97A5-6AFF49FD9359@intel.com>
 <20140922184049.GB4709@pd.tnic>
 <3199350A-89CE-4BE7-8FE4-CA8CE4F87622@intel.com>
 <20140922192152.GD4709@pd.tnic>
 <1411415057.2513.8.camel@jtkirshe-mobl.jf.intel.com>
 <20140922195737.GE4709@pd.tnic>
 <1411416573.2513.19.camel@jtkirshe-mobl.jf.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1411416573.2513.19.camel@jtkirshe-mobl.jf.intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 22, 2014 at 01:09:33PM -0700, Jeff Kirsher wrote:
> Sorry I am very frustrated at your response.

You shouldn't be. Judging by your reply below it seems we do actually
agree... mostly :-)

> I am not saying that the proposed added MACRO is the best solution to
> this issue.  Several other maintainers have actually responded in a
> similar manner to the macros being added and came back that the better
> solution would be to fix the code so that the warnings do not occur in
> the first place.

Right, this would be optimal.

> So I guess I was hoping for more of the response, that "let's fix this
> the code so that the warnings do not appear in the first place".
> 
> I agree with you completely that I do not like the idea of the MACROS
> being added to silence these warnings.  I just disagree that not doing
> anything to fix the warnings is far worse.

Ok, good, so we're on the same page here.

> Why grep through 100,000 warnings, when we should be fixing the code to
> prevent 100,000 warnings.  Not saying that the MACRO is the best
> solution, it is just a solution, in hopes that it spurs discussions like
> this on how to properly fix the warnings.  Not a discussion on how to
> grep through the warnings and do nothing.

There's only one thing I don't understand: why is so bad to grep through
the warnings? I mean, sure, fixing them *without* jumping through hoops
to do so is the optimal thing. But what's wrong with grepping through
them?

Btw, out of curiosity, what is your use case for staring at those W=2
warnings?

In thinking about it, what we could also do is simply move the noisiest
ones to W=3 or so, or even add another W= level. It'll be interesting to
hear your use case though. AFAICT, this is the first time I hear of a
more, let's say, serious use case of W= since we added the W= things a
couple of years ago. :-)

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
