Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759634AbaGXP57 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 11:57:59 -0400
Received: from mail-pd0-f178.google.com ([209.85.192.178]:34433 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759588AbaGXP56 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 11:57:58 -0400
Message-ID: <53D12B9D.9000309@gmail.com>
Date: Thu, 24 Jul 2014 09:51:57 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Arnaldo Carvalho de Melo <acme@kernel.org>, Jiri Olsa <jolsa@redhat.com>
CC: Adrian Hunter <adrian.hunter@intel.com>, Andi Kleen <andi@firstfloor.org>,
        Jiri Olsa <jolsa@kernel.org>, linux-kernel@vger.kernel.org,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Jean Pihet <jean.pihet@linaro.org>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCHv3 00/19] perf tools: Factor ordered samples queue
References: <1405893363-21967-1-git-send-email-jolsa@kernel.org> <53CCB6AE.6020505@intel.com> <20140721080219.GA4183@krava.redhat.com> <53CCD3A7.5070002@intel.com> <20140721095415.GB8865@krava.redhat.com> <87d2cy3c7m.fsf@tassilo.jf.intel.com> <53CD5AB5.3000307@intel.com> <53CD5DC6.3030605@gmail.com> <20140724141958.GB7831@kernel.org> <20140724145611.GB25165@krava.brq.redhat.com> <20140724151009.GD7831@kernel.org>
In-Reply-To: <20140724151009.GD7831@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/24/14, 9:10 AM, Arnaldo Carvalho de Melo wrote:
>
> I haven't seen this comment, just saw David, IIUC, having problems using
> the whole patchkit, David?

The testing I did with the whole patchkit saw no behavior differences.

>
> My tests were more to counter what he said, i.e. that:
>
> <quote David Ahern>
> No overload condition, no dropped chunks message - yet can't process
> events
> </>

Meaning I hit that problem with current code as well as Jiri's changes.

Overall I am fine with the changes. Yes, you can add my Acked-by on all 
of them.

Thanks,
David
