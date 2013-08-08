Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754264Ab3HHETy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Aug 2013 00:19:54 -0400
Received: from mail-ie0-f169.google.com ([209.85.223.169]:45095 "EHLO
	mail-ie0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752005Ab3HHETx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Aug 2013 00:19:53 -0400
MIME-Version: 1.0
In-Reply-To: <20130807202619.GH2665@ghostprotocols.net>
References: <1372941691-14684-1-git-send-email-artagnon@gmail.com>
 <1372941691-14684-5-git-send-email-artagnon@gmail.com> <20130716171940.GA2559@ghostprotocols.net>
 <CALkWK0=kdW3qXCFMYf+WJwPZ4PW3m0bjrenHtqx30PrPfMX5tg@mail.gmail.com> <20130807202619.GH2665@ghostprotocols.net>
From: Ramkumar Ramachandra <artagnon@gmail.com>
Date: Thu, 8 Aug 2013 09:49:12 +0530
Message-ID: <CALkWK0kL0kynNiEVHYrPCRaTZpCVAZsRbcdcHf5XHhNLwtM3wQ@mail.gmail.com>
Subject: Re: [PATCH 4/7] perf completion: modernize style
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arnaldo Carvalho de Melo wrote:
> Can you check how is this in the current perf/core branch so that we can
> move forward while I process some other patches?

This series (except this part) was merged into perf/completion of
git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux 3 weeks ago,
so I'm not sure what perf/core has to do with it.

To answer your question about prevalent style:

  $ git grep "[^ ]()" -- \*.sh

returns many more results than

  $ git grep " ()" -- \*.sh

This is different from what you will see in git.git.

Anyway, consistent style is important in shell scripts mainly because
we don't have semantic parsers and have to rely on it being grep'able
to find something. So, yeah: perf/completion is good as it is.

Thanks.
