Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753832AbaDCVwl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2014 17:52:41 -0400
Received: from mail-ie0-f181.google.com ([209.85.223.181]:63463 "EHLO
	mail-ie0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753329AbaDCVwj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2014 17:52:39 -0400
MIME-Version: 1.0
In-Reply-To: <1395873845-466-1-git-send-email-artagnon@gmail.com>
References: <1395873845-466-1-git-send-email-artagnon@gmail.com>
From: Ramkumar Ramachandra <artagnon@gmail.com>
Date: Thu, 3 Apr 2014 17:51:58 -0400
Message-ID: <CALkWK0kcg0SWrwF0w51L5XuwsBvDO2DZ9em4eYdebo4fjEBAZQ@mail.gmail.com>
Subject: Re: [PATCH] perf tools: Pick up libdw without explicit LIBDW_DIR
To: LKML <linux-kernel@vger.kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>, Arnaldo Carvalho de Melo <acme@redhat.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ramkumar Ramachandra wrote:
>  tools/perf/config/Makefile | 5 ++---
>  1 file changed, 2 insertions(+), 3 deletions(-)

Jiri, any comments?

Ram
