Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932232Ab3KXGdV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Nov 2013 01:33:21 -0500
Received: from mail-ie0-f176.google.com ([209.85.223.176]:60329 "EHLO
	mail-ie0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752811Ab3KXGdT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Nov 2013 01:33:19 -0500
MIME-Version: 1.0
In-Reply-To: <20131122151451.GC10881@krava.brq.redhat.com>
References: <1385044427-13995-1-git-send-email-artagnon@gmail.com>
 <1385044427-13995-5-git-send-email-artagnon@gmail.com> <20131122151451.GC10881@krava.brq.redhat.com>
From: Ramkumar Ramachandra <artagnon@gmail.com>
Date: Sun, 24 Nov 2013 12:02:39 +0530
Message-ID: <CALkWK0mBGiufBbx-7Gado0bWQX81iD6R8AAo9B0Z_gRJttvSbg@mail.gmail.com>
Subject: Re: [INCOMPLETE PATCH 4/4] perf diff: give Ratio column an
 appropriate color
To: Jiri Olsa <jolsa@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jiri Olsa wrote:
>>  The incomplete bit is marked using a TODO; removing two trailing '%'
>>  symbols doesn't seem to work. Can someone please tell me how to fix
>>  this problem?
>
> aah here it is..

I fixed it and sent another iteration.
