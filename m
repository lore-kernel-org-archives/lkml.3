Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757037AbaDWQqB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 12:46:01 -0400
Received: from mail-pb0-f48.google.com ([209.85.160.48]:33523 "EHLO
	mail-pb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756875AbaDWQp7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 12:45:59 -0400
Message-ID: <5357EE44.4080406@gmail.com>
Date: Wed, 23 Apr 2014 10:45:56 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Jiri Olsa <jolsa@redhat.com>
CC: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Don Zickus <dzickus@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 3/5] perf tools: Reference count map_groups objects
References: <1397490723-1992-1-git-send-email-jolsa@redhat.com> <1397490723-1992-4-git-send-email-jolsa@redhat.com> <534C193A.2000806@gmail.com> <20140415095657.GC1700@krava.brq.redhat.com> <534D77B2.1070404@gmail.com> <20140423163117.GA5048@krava.brq.redhat.com>
In-Reply-To: <20140423163117.GA5048@krava.brq.redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/23/14, 10:31 AM, Jiri Olsa wrote:
> thoughts?;-)  thanks,

Only that libperf is still a pipe dream. Don't hold up progress for 
this, but we should be thinking about making it thread safe.

David
