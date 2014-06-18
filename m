Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966129AbaFRLJB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 07:09:01 -0400
Received: from cantor2.suse.de ([195.135.220.15]:41837 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965568AbaFRLI7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 07:08:59 -0400
Message-ID: <53A17347.9010607@suse.cz>
Date: Wed, 18 Jun 2014 13:08:55 +0200
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Ilya Dryomov <idryomov@gmail.com>
CC: Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        linux-kbuild@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] deb-pkg: Fix for relative paths
References: <CAOi1vP9YvbroujXEut6Xn-tvv07MNuxanwDrRvDFhS_-HT_5Lg@mail.gmail.com>	<1402928339-29785-1-git-send-email-mmarek@suse.cz>	<CAADnVQJakSFP8VHJUwh6Z94XkYH7neuamUxHUZ16Q4-YP7O9OQ@mail.gmail.com> <CAOi1vP8udouMMHLYUAFT6xo1nQu4RXJkbTBBjpwG3ivNHVWDVw@mail.gmail.com>
In-Reply-To: <CAOi1vP8udouMMHLYUAFT6xo1nQu4RXJkbTBBjpwG3ivNHVWDVw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dne 18.6.2014 09:52, Ilya Dryomov napsal(a):
> On Tue, Jun 17, 2014 at 6:47 AM, Alexei Starovoitov
> <alexei.starovoitov@gmail.com> wrote:
>> On Mon, Jun 16, 2014 at 7:18 AM, Michal Marek <mmarek@suse.cz> wrote:
>>> When $srctree or $objtree are relative paths, we cannot change directory
>>> and refer to them in the same subshell. Do the redirection outside of
>>> the subshell to fix this.
>>>
>>> Reported-by: Ilya Dryomov <idryomov@gmail.com>
>>> Signed-off-by: Michal Marek <mmarek@suse.cz>
>>> ---
>>>  scripts/package/builddeb | 10 +++++-----
>>>  1 file changed, 5 insertions(+), 5 deletions(-)
>>
>> this patch didn't help to fix the broken deb-pkg for me:
> 
> Alexei, you must have some other issue with your environment.  This
> patch fixes it for me, and in fact I had almost the exact same patch
> committed internally in the interim.  (I wanted to give Michal the
> opportunity to fix this perhaps in a more general way, since tar
> targets seems to misbehave too.)

So can I add your Tested-by: and send it to Linus? I haven't managed to
set up a debian building environment yesterday and I'm a bit busy today.

Thanks,
Michal

