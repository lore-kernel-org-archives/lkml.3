Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754625Ab3HEGCb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 02:02:31 -0400
Received: from e28smtp07.in.ibm.com ([122.248.162.7]:47109 "EHLO
	e28smtp07.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753153Ab3HEGCa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 02:02:30 -0400
Message-ID: <51FF3FE5.3050801@linux.vnet.ibm.com>
Date: Mon, 05 Aug 2013 14:02:13 +0800
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
Subject: Re: [PATCH 2/9] perf stats: add max and min stats
References: <1375473947-64285-1-git-send-email-dsahern@gmail.com> <1375473947-64285-3-git-send-email-dsahern@gmail.com>
In-Reply-To: <1375473947-64285-3-git-send-email-dsahern@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13080505-8878-0000-0000-0000083F9913
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/03/2013 04:05 AM, David Ahern wrote:
> Need an initialization function to set min to -1 to
> differentiate from an actual min of 0.

Reviewed-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>

