Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757241Ab3AYMuZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 07:50:25 -0500
Received: from relay.parallels.com ([195.214.232.42]:47247 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756678Ab3AYMuW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 07:50:22 -0500
Message-ID: <51027F82.8040708@parallels.com>
Date: Fri, 25 Jan 2013 16:50:10 +0400
From: "Maxim V. Patlasov" <mpatlasov@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130107 Thunderbird/17.0.2
MIME-Version: 1.0
To: Miklos Szeredi <miklos@szeredi.hu>
CC: Kirill Korotaev <dev@parallels.com>,
        "fuse-devel@lists.sourceforge.net" <fuse-devel@lists.sourceforge.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        James Bottomley <jbottomley@parallels.com>,
        "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        Pavel Emelianov <xemul@parallels.com>
Subject: Re: [PATCH v2 00/14] fuse: An attempt to implement a write-back cache
 policy
References: <20121116170123.3196.93431.stgit@maximpc.sw.ru> <50C89A78.4010309@parallels.com> <50F573CA.90402@parallels.com> <CAJfpegsp5_Mges1NAZbPSn-q+0O_EgJyroQsf-Vjy20O8DmfLA@mail.gmail.com>
In-Reply-To: <CAJfpegsp5_Mges1NAZbPSn-q+0O_EgJyroQsf-Vjy20O8DmfLA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.30.17.2]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Miklos,

01/25/2013 02:21 PM, Miklos Szeredi пишет:
> On Tue, Jan 15, 2013 at 4:20 PM, Maxim V. Patlasov
> <mpatlasov@parallels.com> wrote:
>> Heard nothing from you for two months. Any feedback would still be
>> appreciated.
> Sorry about the long silence.
>
> I haven't done a detailed review yet.  It would be good if you could
> resent the patchset against for-next branch of the fuse tree.

OK.

> I see that you have some other patchsets pending.   Are they independent?

They are logically independent, but some of them may require cosmetic 
changes to be applied on the top of others.

Thanks,
Maxim
