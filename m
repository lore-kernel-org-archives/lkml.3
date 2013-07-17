Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755389Ab3GQNbh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 09:31:37 -0400
Received: from mail-pb0-f54.google.com ([209.85.160.54]:43812 "EHLO
	mail-pb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753466Ab3GQNbg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 09:31:36 -0400
Message-ID: <51E69CB4.9060905@gmail.com>
Date: Wed, 17 Jul 2013 07:31:32 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.8; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: Namhyung Kim <namhyung@kernel.org>
CC: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>
Subject: Re: [PATCH] perf symbol: Do not apply symfs for an absolute vmlinux
 path
References: <1374048495-3643-1-git-send-email-namhyung@kernel.org>
In-Reply-To: <1374048495-3643-1-git-send-email-namhyung@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/17/13 2:08 AM, Namhyung Kim wrote:
> From: Namhyung Kim <namhyung.kim@lge.com>
>
> If an user gives both of --symfs and --vmlinux option, the vmlinux
> will be searched under the symfs directory.  This is somewhat
> confusing since vmlinux often lives in kernel build directory or
> somewhere other than user space binaries.
>
> So it'd be better not adding symfs prefix for a vmlinux if it has an
> absolute pathname.
>
> Reported-by: Kwanghyun Yoo <ykh815.yoo@lge.com>
> Signed-off-by: Namhyung Kim <namhyung@kernel.org>

Acked-by: David Ahern <dsahern@gmail.com>
