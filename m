Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755345AbaDTL37 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Apr 2014 07:29:59 -0400
Received: from mail-qc0-f171.google.com ([209.85.216.171]:37613 "EHLO
	mail-qc0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755187AbaDTL3w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Apr 2014 07:29:52 -0400
Date: Sun, 20 Apr 2014 07:29:48 -0400
From: Tejun Heo <tj@kernel.org>
To: Lai Jiangshan <laijs@cn.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Jean Delvare <jdelvare@suse.de>,
        Monam Agarwal <monamagarwal123@gmail.com>,
        Jeff Layton <jlayton@redhat.com>,
        Andreas Gruenbacher <agruen@linbit.com>,
        Stephen Hemminger <stephen@networkplumber.org>
Subject: Re: [PATCH 9/9 V2] idr: remove useless C-PreProcessor branch
Message-ID: <20140420112948.GA13298@mtj.dyndns.org>
References: <1397825404-12039-1-git-send-email-laijs@cn.fujitsu.com>
 <1397907496-5993-1-git-send-email-laijs@cn.fujitsu.com>
 <1397907496-5993-10-git-send-email-laijs@cn.fujitsu.com>
 <20140419235104.GE3277@htj.dyndns.org>
 <CACvQF533C6+afNCrpkJbVWVaMaSq7EmajzSDqmCj1FS3BCayCQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACvQF533C6+afNCrpkJbVWVaMaSq7EmajzSDqmCj1FS3BCayCQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Sun, Apr 20, 2014 at 11:56:02AM +0800, Lai Jiangshan wrote:
> On Sun, Apr 20, 2014 at 7:51 AM, Tejun Heo <tj@kernel.org> wrote:
> > $SUBJ: idr: remove useless #ifndef TEST
> >
> > On Sat, Apr 19, 2014 at 07:38:16PM +0800, Lai Jiangshan wrote:
> >> "#ifndef TEST" can't work for user space test now, just remove it.
> >>
> >> Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
> >
> > Acked-by: Tejun Heo <tj@kernel.org>
> 
> Hi, Tejun
> 
> Will you accept the acked patches into your tj/misc.git tree?
> (Or somebody else accepts the idr patches?).

I can route them through misc or Andrew can take them through -mm,
which probably would be better.

> 5/9 will be sent later (in other patchset)
> 6/8 will be dropped.

Andrew, can you please take the acked patches?

Thanks.

-- 
tejun
