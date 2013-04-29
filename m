Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756921Ab3D2C50 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Apr 2013 22:57:26 -0400
Received: from mail-ie0-f182.google.com ([209.85.223.182]:41599 "EHLO
	mail-ie0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756674Ab3D2C5Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Apr 2013 22:57:24 -0400
MIME-Version: 1.0
In-Reply-To: <201304252120.GII21814.FMJFtHLOOVQFOS@I-love.SAKURA.ne.jp>
References: <201304242108.FDC35910.VJMHFFFSOLOOQt@I-love.SAKURA.ne.jp> <201304252120.GII21814.FMJFtHLOOVQFOS@I-love.SAKURA.ne.jp>
From: Zhan Jianyu <nasa4836@gmail.com>
Date: Mon, 29 Apr 2013 10:56:44 +0800
Message-ID: <CAHz2CGXXbg8P94uLcN0K6yxLYg__HB75tGrpw9xR1Rqn=6ZhGg@mail.gmail.com>
Subject: Re: [linux-next-20130422] Bug in SLAB?
To: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Cc: glommer@parallels.com, cl@linux.com, penberg@kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 25, 2013 at 8:20 PM, Tetsuo Handa
<penguin-kernel@i-love.sakura.ne.jp> wrote:
> Bisection (with a build fix from commit db845067 "slab: Fixup
> CONFIG_PAGE_ALLOC/DEBUG_SLAB_LEAK sections") reached commit e3366016
> "slab: Use common kmalloc_index/kmalloc_size functions".
> Would you have a look at commit e3366016?


Cc:   linux-mm@kvack.org



--

Regards,
Zhan Jianyu
