Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933100Ab3HGU0d (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 16:26:33 -0400
Received: from mail-gh0-f181.google.com ([209.85.160.181]:55093 "EHLO
	mail-gh0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932343Ab3HGU0b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 16:26:31 -0400
Date: Wed, 7 Aug 2013 17:26:19 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Ramkumar Ramachandra <artagnon@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 4/7] perf completion: modernize style
Message-ID: <20130807202619.GH2665@ghostprotocols.net>
References: <1372941691-14684-1-git-send-email-artagnon@gmail.com>
 <1372941691-14684-5-git-send-email-artagnon@gmail.com>
 <20130716171940.GA2559@ghostprotocols.net>
 <CALkWK0=kdW3qXCFMYf+WJwPZ4PW3m0bjrenHtqx30PrPfMX5tg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALkWK0=kdW3qXCFMYf+WJwPZ4PW3m0bjrenHtqx30PrPfMX5tg@mail.gmail.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Tue, Jul 16, 2013 at 10:52:55PM +0530, Ramkumar Ramachandra escreveu:
> Arnaldo Carvalho de Melo wrote:
> > Huh? Why would this be more "modern", if both are equivalent, I think
> > applying the same rules as we have for C code applies here.
> 
> It's the prevalent style in git.git, and I figured that it was picked
> up from linux.git but didn't check.  Drop this part otherwise.

Can you check how is this in the current perf/core branch so that we can
move forward while I process some other patches?

- Arnaldo
