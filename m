Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754562AbaHNUHa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2014 16:07:30 -0400
Received: from mail-ig0-f171.google.com ([209.85.213.171]:64413 "EHLO
	mail-ig0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754101AbaHNUH3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2014 16:07:29 -0400
MIME-Version: 1.0
In-Reply-To: <20140814182938.13429.90615.stgit@kbuild-fedora.novalocal>
References: <53ECF7E9.3050200@hitachi.com>
	<20140814182938.13429.90615.stgit@kbuild-fedora.novalocal>
Date: Thu, 14 Aug 2014 13:07:28 -0700
Message-ID: <CAE40pdd_Fy-x5VuhAt46YWSAWmd3z6C5A3DeB6AjBQF4YDZKXw@mail.gmail.com>
Subject: Re: [PATCH] perf probe: Warn user to rebuild target with debuginfo
From: Brendan Gregg <brendan.d.gregg@gmail.com>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>,
        Namhyung Kim <namhyung@gmail.com>, yrl.pp-manager.tt@hitachi.com,
        Jiri Olsa <jolsa@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        David Ahern <dsahern@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 14, 2014 at 11:29 AM, Masami Hiramatsu
<masami.hiramatsu.pt@hitachi.com> wrote:
[...]
> The "rebuild with ..." part changes to "rebuild with CONFIG_DEBUG_INFO"
> if the target is the kernel or a kernel module.

Thanks, definitely an improvement! Should the kernel message also
mention kernel debuginfo packages? Depends on the distribution and
environment, but I think for some users the solution is to add the
package.

Brendan
