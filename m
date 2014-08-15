Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754988AbaHODjy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2014 23:39:54 -0400
Received: from mail-ig0-f177.google.com ([209.85.213.177]:61519 "EHLO
	mail-ig0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754583AbaHODjw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2014 23:39:52 -0400
MIME-Version: 1.0
In-Reply-To: <53ED67A1.3080607@hitachi.com>
References: <53ED627E.2090804@hitachi.com>
	<20140815014432.29869.57941.stgit@kbuild-fedora.novalocal>
	<53ED67A1.3080607@hitachi.com>
Date: Thu, 14 Aug 2014 20:39:51 -0700
Message-ID: <CAE40pdcAoBzFAd1i7B2Q6BMPrxvYkwYd7FP5XFjF-waGosF0Gw@mail.gmail.com>
Subject: Re: [PATCH] perf probe: Warn user to rebuild target with debuginfo
From: Brendan Gregg <brendan.d.gregg@gmail.com>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>,
        Namhyung Kim <namhyung@gmail.com>, David Ahern <dsahern@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, yrl.pp-manager.tt@hitachi.com,
        Jiri Olsa <jolsa@redhat.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 14, 2014 at 6:51 PM, Masami Hiramatsu
<masami.hiramatsu.pt@hitachi.com> wrote:
> Here is v2 patch, which I've added "or install an appropriate debuginfo pacakge." :)
[...]

Looks good, thanks.

Brendan
