Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932423AbaCRPHL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 11:07:11 -0400
Received: from mail-pb0-f49.google.com ([209.85.160.49]:53392 "EHLO
	mail-pb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755692AbaCRPHJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 11:07:09 -0400
Message-ID: <53286118.9070606@gmail.com>
Date: Tue, 18 Mar 2014 09:07:04 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Namhyung Kim <namhyung@kernel.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@kernel.org>,
        Paul Mackerras <paulus@samba.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Andi Kleen <andi@firstfloor.org>
Subject: Re: [RFC/PATCHSET 00/14] perf report: Add -F option for specifying
 output fields (v2)
References: <1395124359-11744-1-git-send-email-namhyung@kernel.org>
In-Reply-To: <1395124359-11744-1-git-send-email-namhyung@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/18/14, 12:32 AM, Namhyung Kim wrote:
> This is a patchset implementing -F/--field option to setup output
> field/column as Ingo requested.  It depends on my perf/percentage
> patchset (with minor updates) [1].

perf-report should be consistent with perf-script which uses --fields.

David
