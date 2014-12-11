Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967544AbaLKXCd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2014 18:02:33 -0500
Received: from mail-qc0-f179.google.com ([209.85.216.179]:40910 "EHLO
	mail-qc0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967345AbaLKW71 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2014 17:59:27 -0500
Message-ID: <548A21CB.6040200@mvista.com>
Date: Thu, 11 Dec 2014 16:59:23 -0600
From: Corey Minyard <cminyard@mvista.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: linux-kernel <linux-kernel@vger.kernel.org>,
        Tony Rex <tony.rex@ericsson.com>,
        Magnus Johansson E <magnus.e.johansson@ericsson.com>,
        =?UTF-8?B?UGVyIEZv?= =?UTF-8?B?Z2Vsc3Ryw7Zt?= 
	<per.fogelstrom@ericsson.com>,
        Jeremy Kerr <jk@ozlabs.org>, Michael Ellerman <mpe@ellerman.id.au>,
        Sanjeev <singhsan@codeaurora.org>, Thomas Renninger <trenn@suse.de>,
        "openipmi-developer@lists.sourceforge.net" 
	<openipmi-developer@lists.sourceforge.net>
Subject: Re: [GIT PULL] ipmi driver updates
References: <54873864.3050606@mvista.com>	<CA+55aFwYTY1gzRF26cZi2nMm6vDPfEBiSfZmXEUtWa39YjcSRg@mail.gmail.com>	<548A1C61.9060905@mvista.com> <CA+55aFwtWcWjqm05DN5xpemmNtCEkgjx0v_uWsy4c0LWP2FNeA@mail.gmail.com>
In-Reply-To: <CA+55aFwtWcWjqm05DN5xpemmNtCEkgjx0v_uWsy4c0LWP2FNeA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/11/2014 04:40 PM, Linus Torvalds wrote:
> On Thu, Dec 11, 2014 at 2:36 PM, Corey Minyard <cminyard@mvista.com> wrote:
>>   git://git.code.sf.net/p/openipmi/linux-ipmi openipmi-linux-ipmi for-linus
> So I see a "for-linus" tag now, but what's that "openipmi-linux-ipmi"
> thing in there?

That's a cut and paste error.  I cut from the wrong place, it appears.

>
> Also, just in general, please use the normal "git pull-request"
> script, which should make these kinds of things clear and error out if
> the tag isn't found (at least in current versions of git).
>
>> Also, there was nothing in SubmittingPatches that I could find about
>> signing the tags for pull requests.  I can try to write something to add
>> there, if you like.  Though someone with more experience might be a
>> better candidate.
> Hmm. You might want to google around too, because this has come up
> before, so there might be explanations lying around on the mailing
> lists that just haven't been made into documentation.

Ok, I'll try to poke around and see what I can find.

-corey
