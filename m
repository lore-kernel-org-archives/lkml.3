Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754085AbaDWGlm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 02:41:42 -0400
Received: from mail-ie0-f177.google.com ([209.85.223.177]:47755 "EHLO
	mail-ie0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753363AbaDWGlk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 02:41:40 -0400
MIME-Version: 1.0
In-Reply-To: <20140422124920.e22ed65d33d2b982ef467372@linux-foundation.org>
References: <cover.1398147734.git.nasa4836@gmail.com> <2c63c535f8202c6b605300a834cdf1c07d1bafc3.1398147734.git.nasa4836@gmail.com>
 <20140422124920.e22ed65d33d2b982ef467372@linux-foundation.org>
From: Jianyu Zhan <nasa4836@gmail.com>
Date: Wed, 23 Apr 2014 14:41:00 +0800
Message-ID: <CAHz2CGUV7HQYkKzwhw-JNiwHTHX8Djp-ReC23i+=1jaM1YaowQ@mail.gmail.com>
Subject: Re: [PATCH 2/4] mm/memcontrol.c: use accessor to get id from css
To: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>
Cc: Tejun Heo <tj@kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 23, 2014 at 3:49 AM, Andrew Morton
<akpm@linux-foundation.org> wrote:
> I'd expect Tejun to process this series, but you didn't cc him on 2/4.

Oh, I reposed too much confidence in get_maintainer.pl.  I thought it
would cc tj as usual. :-)

Tj said he has a patchset queued for addressing this problem and will
be sent out soon,
so just forget this patch and wait.


Thanks,
Jianyu Zhan
