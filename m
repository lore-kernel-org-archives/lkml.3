Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934195Ab3CMT5I (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Mar 2013 15:57:08 -0400
Received: from mail-ye0-f179.google.com ([209.85.213.179]:45746 "EHLO
	mail-ye0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932236Ab3CMT5H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Mar 2013 15:57:07 -0400
Date: Wed, 13 Mar 2013 16:56:56 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: David Ahern <dsahern@gmail.com>
Cc: Namhyung Kim <namhyung@kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: perf fails to compile for latest Linus tree
Message-ID: <20130313195656.GG11779@ghostprotocols.net>
References: <5140923B.4040102@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <5140923B.4040102@gmail.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Wed, Mar 13, 2013 at 08:50:35AM -0600, David Ahern escreveu:
> I believe this has been fixed but I don't see it in your tree
> (perf/core or perf/urgent) or in the tip tree:
 
> builtin-annotate.c: In function ‘hists__find_annotations’:
> builtin-annotate.c:161:4: error: duplicate case value
> builtin-annotate.c:154:4: error: previously used here
> make: *** [/tmp/pbuild/builtin-annotate.o] Error 1
> make: *** Waiting for unfinished jobs....

Yeah, this is because you don't have newt-devel installed, please try
with acme/perf/urgent after two patches from Michael Ellerman appear at
its head, I just pushed it.

- Arnaldo
