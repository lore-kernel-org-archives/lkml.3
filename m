Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933526Ab3GPRXj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jul 2013 13:23:39 -0400
Received: from mail-ie0-f177.google.com ([209.85.223.177]:59915 "EHLO
	mail-ie0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933059Ab3GPRXg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jul 2013 13:23:36 -0400
MIME-Version: 1.0
In-Reply-To: <20130716171940.GA2559@ghostprotocols.net>
References: <1372941691-14684-1-git-send-email-artagnon@gmail.com>
 <1372941691-14684-5-git-send-email-artagnon@gmail.com> <20130716171940.GA2559@ghostprotocols.net>
From: Ramkumar Ramachandra <artagnon@gmail.com>
Date: Tue, 16 Jul 2013 22:52:55 +0530
Message-ID: <CALkWK0=kdW3qXCFMYf+WJwPZ4PW3m0bjrenHtqx30PrPfMX5tg@mail.gmail.com>
Subject: Re: [PATCH 4/7] perf completion: modernize style
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arnaldo Carvalho de Melo wrote:
> Huh? Why would this be more "modern", if both are equivalent, I think
> applying the same rules as we have for C code applies here.

It's the prevalent style in git.git, and I figured that it was picked
up from linux.git but didn't check.  Drop this part otherwise.

Thanks.
