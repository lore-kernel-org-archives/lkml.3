Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934954Ab3DKQmz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 12:42:55 -0400
Received: from relay.parallels.com ([195.214.232.42]:39423 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765434Ab3DKQmy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 12:42:54 -0400
Message-ID: <5166E81B.8060507@parallels.com>
Date: Thu, 11 Apr 2013 20:43:07 +0400
From: "Maxim V. Patlasov" <mpatlasov@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130328 Thunderbird/17.0.5
MIME-Version: 1.0
To: Miklos Szeredi <miklos@szeredi.hu>
CC: <dev@parallels.com>, <xemul@parallels.com>,
        <fuse-devel@lists.sourceforge.net>, <linux-kernel@vger.kernel.org>,
        <devel@openvz.org>
Subject: Re: [fuse-devel] [PATCH v2 0/6] fuse: process direct IO asynchronously
References: <20121214151424.27155.45971.stgit@maximpc.sw.ru> <51669CDF.9090705@parallels.com> <CAJfpegs7EZwmYNPkeE3DK_XyOAZK9nuakT7CEGX0iD88eFcHnw@mail.gmail.com>
In-Reply-To: <CAJfpegs7EZwmYNPkeE3DK_XyOAZK9nuakT7CEGX0iD88eFcHnw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.30.17.2]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

04/11/2013 08:07 PM, Miklos Szeredi пишет:
> Hi Maxim,
>
> On Thu, Apr 11, 2013 at 1:22 PM, Maxim V. Patlasov
> <mpatlasov@parallels.com> wrote:
>> Hi Miklos,
>>
>> Any feedback would be highly appreciated.
> What is the order of all these patchsets with regards to each other?

They are logically independent, so I formed them to be applied w/o each 
other. There might be some minor collisions between them (if you try to 
apply one patch-set on the top of another). So, as soon as you get one 
of them to fuse-next, I'll update others to be applied smoothly. Either 
we can settle down some order now, and I'll do it in advance.

Thanks,
Maxim
