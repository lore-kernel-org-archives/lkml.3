Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754255AbaDKAou (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2014 20:44:50 -0400
Received: from mail-ie0-f172.google.com ([209.85.223.172]:57685 "EHLO
	mail-ie0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753668AbaDKAof (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2014 20:44:35 -0400
MIME-Version: 1.0
In-Reply-To: <20140409125817.GB2556@krava.brq.redhat.com>
References: <1395955661-10056-1-git-send-email-artagnon@gmail.com> <20140409125817.GB2556@krava.brq.redhat.com>
From: Ramkumar Ramachandra <artagnon@gmail.com>
Date: Thu, 10 Apr 2014 20:43:54 -0400
Message-ID: <CALkWK0mRQ6maZNHKoDOPoWXrPHyOCVXgfRXewHS+D9sEPjDv=w@mail.gmail.com>
Subject: Re: [PATCH] perf list: Fix --raw-dump argument
To: Jiri Olsa <jolsa@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>, David Ahern <dsahern@gmail.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jiri Olsa wrote:
> but looks like the usage is for bash completion only, so we probably
> need only the first example functionality above.
>
> If this is the case I think it should not be an option but another
> command like 'raw-dump'.

I decided that there's no point making it an option, so I've sent you
a patch making it a subcommand instead.

Thanks.
