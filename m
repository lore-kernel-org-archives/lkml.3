Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754840Ab3EFSIH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 May 2013 14:08:07 -0400
Received: from mail-da0-f51.google.com ([209.85.210.51]:63708 "EHLO
	mail-da0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753336Ab3EFSIF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 14:08:05 -0400
Message-ID: <5187F180.2000805@gmail.com>
Date: Mon, 06 May 2013 12:08:00 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:17.0) Gecko/20130328 Thunderbird/17.0.5
MIME-Version: 1.0
To: Jiri Olsa <jolsa@redhat.com>
CC: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andi Kleen <andi@firstfloor.org>, Ulrich Drepper <drepper@gmail.com>,
        Will Deacon <will.deacon@arm.com>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 6/8] perf tests: Add automated tests for formula object
References: <1367421346-18257-1-git-send-email-jolsa@redhat.com> <1367421346-18257-7-git-send-email-jolsa@redhat.com> <5183D52D.7060303@gmail.com> <20130506175401.GD4562@krava.brq.redhat.com>
In-Reply-To: <20130506175401.GD4562@krava.brq.redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/6/13 11:54 AM, Jiri Olsa wrote:
> hum, the TEST_ASSERT_VAL call 'return' from __test_basics on error and
> that goes back to test_basics where file_put is called..

ok. I filled in the meaning of TEST_ASSERT_VAL -- thinking it killed the 
program at that point as in assert().

David
