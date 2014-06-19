Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934181AbaFSRyn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 13:54:43 -0400
Received: from mail-pb0-f42.google.com ([209.85.160.42]:60684 "EHLO
	mail-pb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933601AbaFSRym (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 13:54:42 -0400
Message-ID: <53A323E0.8040307@gmail.com>
Date: Thu, 19 Jun 2014 11:54:40 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Jiri Olsa <jolsa@redhat.com>
CC: Jiri Olsa <jolsa@kernel.org>, linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Jean Pihet <jean.pihet@linaro.org>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCHv2 00/18] perf tools: Factor ordered samples queue
References: <1403103539-16807-1-git-send-email-jolsa@kernel.org> <53A1EC2E.1010706@gmail.com> <20140619103448.GA7619@krava.brq.redhat.com>
In-Reply-To: <20140619103448.GA7619@krava.brq.redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/19/14, 4:34 AM, Jiri Olsa wrote:
>> I've skimmed through the patches. What happens if you are in the middle of a
>> round and the max queue size is reached?
>
> half of the queue (time half) is flushed to make some free space

right, I believe there will be scenarios where that will cause failures 
with out of order timestamps.

David
