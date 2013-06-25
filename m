Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752155Ab3FYPnL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 11:43:11 -0400
Received: from mail-pa0-f54.google.com ([209.85.220.54]:48260 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751777Ab3FYPnK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 11:43:10 -0400
Message-ID: <51C9BA7D.1040106@gmail.com>
Date: Tue, 25 Jun 2013 09:42:53 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.8; rv:17.0) Gecko/20130509 Thunderbird/17.0.6
MIME-Version: 1.0
To: Jiri Olsa <jolsa@redhat.com>
CC: Adrian Hunter <adrian.hunter@intel.com>,
        Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH 12/15] perf tools: allow non-matching sample types
References: <1372079772-20803-1-git-send-email-adrian.hunter@intel.com> <1372079772-20803-13-git-send-email-adrian.hunter@intel.com> <CABPqkBRoRgHUM5ahHmvYXJ1BkHncm9Z2GZkzuRFbsNfh4=HJ6g@mail.gmail.com> <51C98969.40401@intel.com> <20130625144529.GL23329@krava.brq.redhat.com>
In-Reply-To: <20130625144529.GL23329@krava.brq.redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/25/13 8:45 AM, Jiri Olsa wrote:
> AFAICS PERF_SAMPLE_STREAM_ID holds same id value as PERF_SAMPLE_ID,
> but I guess it has some other meaning.. if not for now, maybe meant
> something else for the future;-)  not sure

See 7f453c24.

David

