Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752971Ab3IZPtb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 11:49:31 -0400
Received: from mail-ie0-f176.google.com ([209.85.223.176]:41502 "EHLO
	mail-ie0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750975Ab3IZPt2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 11:49:28 -0400
MIME-Version: 1.0
In-Reply-To: <52444F53.504@gmail.com>
References: <1380205304-32224-1-git-send-email-artagnon@gmail.com> <52444F53.504@gmail.com>
From: Ramkumar Ramachandra <artagnon@gmail.com>
Date: Thu, 26 Sep 2013 21:18:48 +0530
Message-ID: <CALkWK0k=c9ov-FWaR8ocD-XjUOEQWCLhv-4OjWFkJYmfMRV=QQ@mail.gmail.com>
Subject: Re: [PATCH] tools/perf: remove non-existent entries in MANIFEST
To: David Ahern <dsahern@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Ahern wrote:
> Did you create a tarfile after this change, unpack it somewhere out of three
> and then verify perf builds?

Yeah, it builds fine. In fact, the archive generated from the current
upstream is broken.
