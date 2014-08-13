Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751731AbaHMFrJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 01:47:09 -0400
Received: from mail-pd0-f175.google.com ([209.85.192.175]:58709 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751122AbaHMFrI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 01:47:08 -0400
Message-ID: <53EAFBDB.8050500@gmail.com>
Date: Tue, 12 Aug 2014 23:47:07 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Namhyung Kim <namhyung@kernel.org>
CC: Arnaldo Carvalho de Melo <acme@kernel.org>,
        Stephane Eranian <eranian@google.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>
Subject: Re: [RFC/PATCH 1/2] perf top: Fix -z option behavior
References: <1407831366-28892-1-git-send-email-namhyung@kernel.org>	<53EA6495.4010600@gmail.com> <87vbpxdm8s.fsf@sejong.aot.lge.com>
In-Reply-To: <87vbpxdm8s.fsf@sejong.aot.lge.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/12/14, 10:52 PM, Namhyung Kim wrote:

> Are you sure?  I don't recall seeing any big change in this area so I
> guess the problem existed since long time ago.  In fact I couldn't find
> a logic to zero/clear out existing hist entries in a hists..

Just gave a quick try. v3.4 fails; v3.1 works.

David
