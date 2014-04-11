Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757292AbaDKNIp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2014 09:08:45 -0400
Received: from mail-ig0-f177.google.com ([209.85.213.177]:56417 "EHLO
	mail-ig0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755324AbaDKNIn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2014 09:08:43 -0400
MIME-Version: 1.0
In-Reply-To: <20140411103253.GA1107@krava.brq.redhat.com>
References: <1397176953-2006-1-git-send-email-artagnon@gmail.com> <20140411103253.GA1107@krava.brq.redhat.com>
From: Ramkumar Ramachandra <artagnon@gmail.com>
Date: Fri, 11 Apr 2014 09:08:03 -0400
Message-ID: <CALkWK0nBi9R9kHi_mPs1n=G77057kP2xG6aehauVcfp6_ymVDg@mail.gmail.com>
Subject: Re: [PATCH v2] perf list: Fix --raw-dump argument
To: Jiri Olsa <jolsa@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>, David Ahern <dsahern@gmail.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jiri Olsa wrote:
> you need to update perf-completion.sh now
> also please add it to perf list man page as well

I updated perf-completion.sh, although I didn't mention it in the
commit message. I'll add it to the perf-list man page and send out
another version.

Ram
