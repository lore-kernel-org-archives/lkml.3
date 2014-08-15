Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751424AbaHONeU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2014 09:34:20 -0400
Received: from mail.kernel.org ([198.145.19.201]:36586 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750967AbaHONeT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2014 09:34:19 -0400
Date: Fri, 15 Aug 2014 10:34:14 -0300
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Brendan Gregg <brendan.d.gregg@gmail.com>,
        Namhyung Kim <namhyung@gmail.com>, David Ahern <dsahern@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, yrl.pp-manager.tt@hitachi.com,
        Jiri Olsa <jolsa@redhat.com>
Subject: Re: [PATCH] perf probe: Warn user to rebuild target with debuginfo
Message-ID: <20140815133414.GA3508@kernel.org>
References: <53ED627E.2090804@hitachi.com>
 <20140815014432.29869.57941.stgit@kbuild-fedora.novalocal>
 <53ED67A1.3080607@hitachi.com>
 <CAE40pdcAoBzFAd1i7B2Q6BMPrxvYkwYd7FP5XFjF-waGosF0Gw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAE40pdcAoBzFAd1i7B2Q6BMPrxvYkwYd7FP5XFjF-waGosF0Gw@mail.gmail.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Thu, Aug 14, 2014 at 08:39:51PM -0700, Brendan Gregg escreveu:
> On Thu, Aug 14, 2014 at 6:51 PM, Masami Hiramatsu
> <masami.hiramatsu.pt@hitachi.com> wrote:
> > Here is v2 patch, which I've added "or install an appropriate debuginfo pacakge." :)
> [...]
> 
> Looks good, thanks.

Thanks, applied.

- Arnaldo
