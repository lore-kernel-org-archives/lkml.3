Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755267AbaDTD4J (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Apr 2014 23:56:09 -0400
Received: from mail-ig0-f182.google.com ([209.85.213.182]:64566 "EHLO
	mail-ig0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752049AbaDTD4D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Apr 2014 23:56:03 -0400
MIME-Version: 1.0
In-Reply-To: <20140419235104.GE3277@htj.dyndns.org>
References: <1397825404-12039-1-git-send-email-laijs@cn.fujitsu.com>
	<1397907496-5993-1-git-send-email-laijs@cn.fujitsu.com>
	<1397907496-5993-10-git-send-email-laijs@cn.fujitsu.com>
	<20140419235104.GE3277@htj.dyndns.org>
Date: Sun, 20 Apr 2014 11:56:02 +0800
X-Google-Sender-Auth: XDbVFrHDM3yhhJuB9btII8Edbd4
Message-ID: <CACvQF533C6+afNCrpkJbVWVaMaSq7EmajzSDqmCj1FS3BCayCQ@mail.gmail.com>
Subject: Re: [PATCH 9/9 V2] idr: remove useless C-PreProcessor branch
From: Lai Jiangshan <laijs@cn.fujitsu.com>
To: Tejun Heo <tj@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jean Delvare <jdelvare@suse.de>,
        Monam Agarwal <monamagarwal123@gmail.com>,
        Jeff Layton <jlayton@redhat.com>,
        Andreas Gruenbacher <agruen@linbit.com>,
        Stephen Hemminger <stephen@networkplumber.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 20, 2014 at 7:51 AM, Tejun Heo <tj@kernel.org> wrote:
> $SUBJ: idr: remove useless #ifndef TEST
>
> On Sat, Apr 19, 2014 at 07:38:16PM +0800, Lai Jiangshan wrote:
>> "#ifndef TEST" can't work for user space test now, just remove it.
>>
>> Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
>
> Acked-by: Tejun Heo <tj@kernel.org>

Hi, Tejun

Will you accept the acked patches into your tj/misc.git tree?
(Or somebody else accepts the idr patches?).

5/9 will be sent later (in other patchset)
6/8 will be dropped.

Thanks,
Lai

>
> Thanks.
>
> --
> tejun
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
