Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753723AbaD1Hxb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 03:53:31 -0400
Received: from mail.skyhub.de ([78.46.96.112]:50058 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750719AbaD1Hxa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 03:53:30 -0400
Date: Mon, 28 Apr 2014 09:53:18 +0200
From: Borislav Petkov <bp@alien8.de>
To: xiakaixu <xiakaixu@huawei.com>, Namhyung Kim <namhyung@kernel.org>
Cc: linux-kernel@vger.kernel.org, paulus@samba.org,
        Ingo Molnar <mingo@kernel.org>, a.p.zijlstra@chello.nl,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Huxinwei <huxinwei@huawei.com>, Genghui <hui.geng@huawei.com>,
        jolsa@redhat.com, peifeiyue@huawei.com
Subject: Re: [PATCH] perf tools: Remove extra '/' character in events file
 path
Message-ID: <20140428075318.GB31522@pd.tnic>
References: <535B6660.2060001@huawei.com>
 <87tx9epawt.fsf@sejong.aot.lge.com>
 <535DB67A.2020108@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <535DB67A.2020108@huawei.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 28, 2014 at 10:01:30AM +0800, xiakaixu wrote:
> >> diff --git a/tools/lib/api/fs/debugfs.c b/tools/lib/api/fs/debugfs.c
> >> index 7c43479..a74fba6 100644
> >> --- a/tools/lib/api/fs/debugfs.c
> >> +++ b/tools/lib/api/fs/debugfs.c
> >> @@ -12,8 +12,8 @@
> >>  char debugfs_mountpoint[PATH_MAX + 1] = "/sys/kernel/debug";
> >>
> >>  static const char * const debugfs_known_mountpoints[] = {
> >> -	"/sys/kernel/debug/",
> >> -	"/debug/",
> >> +	"/sys/kernel/debug",
> >> +	"/debug",

Right, fs/debugfs.c needs to get merged with fs/fs.c at some point.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
