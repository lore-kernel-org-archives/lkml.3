Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752553Ab3JFLPY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Oct 2013 07:15:24 -0400
Received: from mail-ie0-f176.google.com ([209.85.223.176]:48019 "EHLO
	mail-ie0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751618Ab3JFLPX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Oct 2013 07:15:23 -0400
MIME-Version: 1.0
In-Reply-To: <1381055141-25209-1-git-send-email-artagnon@gmail.com>
References: <1381055141-25209-1-git-send-email-artagnon@gmail.com>
From: Ramkumar Ramachandra <artagnon@gmail.com>
Date: Sun, 6 Oct 2013 16:44:42 +0530
Message-ID: <CALkWK0mVOnCe=LgfgHBmPO2rFKj3x8vF-A++mk+QPRQvnL9uww@mail.gmail.com>
Subject: Re: [PATCH] perf tool: don't open-code TEST_EVENTS macro
To: LKML <linux-kernel@vger.kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>, Ingo Molnar <mingo@kernel.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ramkumar Ramachandra wrote:
> The TEST_EVENTS macro is open-coded towards the end of
> test__parse_events(). While at it, undef it cleanly after its usage.

Kindly ignore this patch; I made a trivial mistake.
