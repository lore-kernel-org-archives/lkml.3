Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754194Ab3HEFJ7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 01:09:59 -0400
Received: from e28smtp01.in.ibm.com ([122.248.162.1]:50193 "EHLO
	e28smtp01.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750945Ab3HEFJ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 01:09:58 -0400
Message-ID: <51FF339B.4050500@linux.vnet.ibm.com>
Date: Mon, 05 Aug 2013 13:09:47 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: David Ahern <dsahern@gmail.com>
CC: acme@ghostprotocols.net, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Runzhen Wang <runzhen@linux.vnet.ibm.com>
Subject: Re: [PATCH 4/9] perf kvm: split out tracepoints from record args
References: <1375473947-64285-1-git-send-email-dsahern@gmail.com> <1375473947-64285-5-git-send-email-dsahern@gmail.com>
In-Reply-To: <1375473947-64285-5-git-send-email-dsahern@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13080505-4790-0000-0000-000009A220A0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/03/2013 04:05 AM, David Ahern wrote:
> Needed by kvm live command. Make record_args a local while we are
> messing with the args.

Reviewed-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>

