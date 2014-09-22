Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754338AbaIVTWB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 15:22:01 -0400
Received: from mail.skyhub.de ([78.46.96.112]:56811 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751130AbaIVTV6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 15:21:58 -0400
Date: Mon, 22 Sep 2014 21:21:52 +0200
From: Borislav Petkov <bp@alien8.de>
To: "Rustad, Mark D" <mark.d.rustad@intel.com>
Cc: "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>,
        "sparse@chrisli.org" <sparse@chrisli.org>,
        "linux-sparse@vger.kernel.org" <linux-sparse@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/7] Silence even more W=2 warnings
Message-ID: <20140922192152.GD4709@pd.tnic>
References: <1411140580-20909-1-git-send-email-jeffrey.t.kirsher@intel.com>
 <20140922153355.GB4510@pd.tnic>
 <AEF1C0F7-239C-436B-97A5-6AFF49FD9359@intel.com>
 <20140922184049.GB4709@pd.tnic>
 <3199350A-89CE-4BE7-8FE4-CA8CE4F87622@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <3199350A-89CE-4BE7-8FE4-CA8CE4F87622@intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 22, 2014 at 06:59:23PM +0000, Rustad, Mark D wrote:
> It is helpful for using the warnings to look for problems or even just risks.

That's what W= builds are for.

> Right now the number of warnings generated when using W=2 simply tells
> people to never use W=2.

I showed you how to use W=2 and 3 for that matter - pipe the output into
a file and grep away.

> That severely limits the value of a useful tool. A checkpatch warning
> doesn't mean to never do that, just that it needs a critical look and
> justification. That is certainly true of every patch I made that uses
> those macros.

Sorry, if you need to shut up the compiler by adding code with the sole
purpose to not issue a warning for otherwise perfectly fine code, then
something's wrong with the whole endeavor in the first place.

There's a reason W= warnings are disabled in the default build.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
