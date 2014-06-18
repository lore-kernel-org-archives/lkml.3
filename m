Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966557AbaFRMn1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 08:43:27 -0400
Received: from mail-we0-f181.google.com ([74.125.82.181]:36105 "EHLO
	mail-we0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966306AbaFRMnZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 08:43:25 -0400
MIME-Version: 1.0
In-Reply-To: <53A17347.9010607@suse.cz>
References: <CAOi1vP9YvbroujXEut6Xn-tvv07MNuxanwDrRvDFhS_-HT_5Lg@mail.gmail.com>
	<1402928339-29785-1-git-send-email-mmarek@suse.cz>
	<CAADnVQJakSFP8VHJUwh6Z94XkYH7neuamUxHUZ16Q4-YP7O9OQ@mail.gmail.com>
	<CAOi1vP8udouMMHLYUAFT6xo1nQu4RXJkbTBBjpwG3ivNHVWDVw@mail.gmail.com>
	<53A17347.9010607@suse.cz>
Date: Wed, 18 Jun 2014 16:43:23 +0400
Message-ID: <CAOi1vP9XoZTc4y=N7Q6WD3RS7ZamtWkzvzWGSahBx4ENOjpuEg@mail.gmail.com>
Subject: Re: [PATCH] deb-pkg: Fix for relative paths
From: Ilya Dryomov <idryomov@gmail.com>
To: Michal Marek <mmarek@suse.cz>
Cc: Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        linux-kbuild@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Dne 18.6.2014 09:52, Ilya Dryomov napsal(a):
>> On Tue, Jun 17, 2014 at 6:47 AM, Alexei Starovoitov
>> <alexei.starovoitov@gmail.com> wrote:
>>> On Mon, Jun 16, 2014 at 7:18 AM, Michal Marek <mmarek@suse.cz> wrote:
>>>> When $srctree or $objtree are relative paths, we cannot change directory
>>>> and refer to them in the same subshell. Do the redirection outside of
>>>> the subshell to fix this.
>>>>
>>>> Reported-by: Ilya Dryomov <idryomov@gmail.com>
>>>> Signed-off-by: Michal Marek <mmarek@suse.cz>
>>>> ---
>>>>  scripts/package/builddeb | 10 +++++-----
>>>>  1 file changed, 5 insertions(+), 5 deletions(-)
>>>
>>> this patch didn't help to fix the broken deb-pkg for me:
>>
>> Alexei, you must have some other issue with your environment.  This
>> patch fixes it for me, and in fact I had almost the exact same patch
>> committed internally in the interim.  (I wanted to give Michal the
>> opportunity to fix this perhaps in a more general way, since tar
>> targets seems to misbehave too.)
>
> So can I add your Tested-by: and send it to Linus? I haven't managed to
> set up a debian building environment yesterday and I'm a bit busy today.

Yes, Tested-by: Ilya Dryomov <idryomov@gmail.com>

Thanks,

                Ilya
