Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759105AbaLKWgW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2014 17:36:22 -0500
Received: from mail-qg0-f47.google.com ([209.85.192.47]:40056 "EHLO
	mail-qg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757793AbaLKWgU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2014 17:36:20 -0500
Message-ID: <548A1C61.9060905@mvista.com>
Date: Thu, 11 Dec 2014 16:36:17 -0600
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
References: <54873864.3050606@mvista.com> <CA+55aFwYTY1gzRF26cZi2nMm6vDPfEBiSfZmXEUtWa39YjcSRg@mail.gmail.com>
In-Reply-To: <CA+55aFwYTY1gzRF26cZi2nMm6vDPfEBiSfZmXEUtWa39YjcSRg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/11/2014 02:19 PM, Linus Torvalds wrote:
> On Tue, Dec 9, 2014 at 9:59 AM, Corey Minyard <cminyard@mvista.com> wrote:
>> git://git.code.sf.net/p/openipmi/linux-ipmi openipmi-linux-ipmi for-linus
> Can't do.
>
> Not only is there no "for-linus" branch there, even if there was, I
> wouldn't pull it. I really want signed tags when pulling from random
> git repositories. So when pulling from places like guthub or
> sourceforge, I want that signature to verify the identity of the tree,
> when the site itself doesn't do it.
>
> Please fix up..

Ok, should be fixed up.  I have the opal changes in a topic merge, and
the tag is signed with minyard@acm.org, verified on another machine. 
Please pull from:

  git://git.code.sf.net/p/openipmi/linux-ipmi openipmi-linux-ipmi for-linus

Also, there was nothing in SubmittingPatches that I could find about
signing the tags for pull requests.  I can try to write something to add
there, if you like.  Though someone with more experience might be a
better candidate.

Thanks,

-corey
>
>                      Linus

