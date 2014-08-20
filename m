Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753120AbaHTXQp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 19:16:45 -0400
Received: from mail-vc0-f169.google.com ([209.85.220.169]:37192 "EHLO
	mail-vc0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752846AbaHTXQo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 19:16:44 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.19.4.1408192222470.2758@trent.utfs.org>
References: <1408217806-25877-1-git-send-email-xiyou.wangcong@gmail.com>
	<87ppfvrdux.fsf@x220.int.ebiederm.org>
	<alpine.DEB.2.19.4.1408192222470.2758@trent.utfs.org>
Date: Wed, 20 Aug 2014 19:16:43 -0400
Message-ID: <CAHQdGtQ0_2cnvbuQxYDrU2nuZ2iw1gZtxB5PeR-2QZL008OOwg@mail.gmail.com>
Subject: Re: [PATCH v2] nfs: fix kernel warning when removing proc entry
From: Trond Myklebust <trond.myklebust@primarydata.com>
To: Christian Kujau <lists@nerdbynature.de>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux NFS Mailing List <linux-nfs@vger.kernel.org>,
        Dan Aloni <dan@kernelim.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 20, 2014 at 1:24 AM, Christian Kujau <lists@nerdbynature.de> wrote:
> On Tue, 19 Aug 2014 at 21:20, Eric W. Biederman wrote:
>
>> Cong Wang <xiyou.wangcong@gmail.com> writes:
>>
>> > I saw the following kernel warning:
>>
>> Cong thanks for finding and tracking this.  I was clearly asleep at the
>> switch when I was testing my fix to the nfs client code :(
>>
>> I have applied this patch and will push it to Linus after it has a
>> little bit to sit in linux-next.
>
> This made the boot warning go away for me as well:
> http://lkml.iu.edu/hypermail/linux/kernel/1408.2/01792.html
>
> Tested-by: Christian Kujau <lists@nerdbynature.de>
>
> Thanks!
> Christian.
> --
> BOFH excuse #182:
>
> endothermal recalibration

It is customary (and expected!) to send these patches through the
maintainer; not to push them yourself.

-- 
Trond Myklebust

Linux NFS client maintainer, PrimaryData

trond.myklebust@primarydata.com
