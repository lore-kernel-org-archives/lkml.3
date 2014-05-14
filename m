Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753251AbaENWIh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 18:08:37 -0400
Received: from mail-ve0-f170.google.com ([209.85.128.170]:38283 "EHLO
	mail-ve0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751559AbaENWIf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 18:08:35 -0400
MIME-Version: 1.0
In-Reply-To: <20140514220143.GA20841@quack.suse.cz>
References: <20140503223324.4357f591dc8994b74f456440@skynet.be>
	<20140514220143.GA20841@quack.suse.cz>
Date: Thu, 15 May 2014 00:08:34 +0200
Message-ID: <CAFLxGvzp_8Qgg0wN2v0SncAB+eDEn4s-p86ZW9+DzosBKb53yw@mail.gmail.com>
Subject: Re: [PATCH V2] fs/reiserfs/stree.c: remove obsolete __constant
From: Richard Weinberger <richard.weinberger@gmail.com>
To: Jan Kara <jack@suse.cz>
Cc: Fabian Frederick <fabf@skynet.be>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        reiserfs-devel@vger.kernel.org, akpm <akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 15, 2014 at 12:01 AM, Jan Kara <jack@suse.cz> wrote:
> On Sat 03-05-14 22:33:24, Fabian Frederick wrote:
>> __constant_cpu_to_le32 converted to cpu_to_le32
>>
>> Cc: reiserfs-devel@vger.kernel.org
>> Cc: Andrew Morton <akpm@linux-foundation.org>
>> Signed-off-by: Fabian Frederick <fabf@skynet.be>
>   Just for my education, where have you learned that __constant_...
> functions are obsolete?

IIRC checkpatch.pl barks if you use __constant_... outside of include/uapi/

-- 
Thanks,
//richard
