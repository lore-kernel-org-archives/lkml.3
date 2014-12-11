Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934153AbaLKRGl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2014 12:06:41 -0500
Received: from mail-pa0-f44.google.com ([209.85.220.44]:65016 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932626AbaLKRGj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2014 12:06:39 -0500
Message-ID: <5489CF1C.5090606@gmail.com>
Date: Thu, 11 Dec 2014 10:06:36 -0700
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Jiri Olsa <jolsa@kernel.org>, linux-kernel@vger.kernel.org
CC: Arnaldo Carvalho de Melo <acme@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Jeremie Galarneau <jgalar@efficios.com>,
        Namhyung Kim <namhyung@gmail.com>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Tom Zanussi <tzanussi@gmail.com>
Subject: Re: [PATCH 3/8] perf data: Add perf data to CTF conversion support
References: <1418310749-22267-1-git-send-email-jolsa@kernel.org> <1418310749-22267-4-git-send-email-jolsa@kernel.org>
In-Reply-To: <1418310749-22267-4-git-send-email-jolsa@kernel.org>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/11/14 8:12 AM, Jiri Olsa wrote:
> To convert perf.data into CTF run:
>    $ perf data convert --to-ctf=./ctf-data/


Are you expecting to need a --from-ctf? if not should that just be --ctf?

David
