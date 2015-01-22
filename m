Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754522AbbAVDxL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 22:53:11 -0500
Received: from mail-pa0-f42.google.com ([209.85.220.42]:33986 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750877AbbAVDxH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 22:53:07 -0500
Message-ID: <54C0744B.9030202@gmail.com>
Date: Wed, 21 Jan 2015 20:53:47 -0700
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:31.0) Gecko/20100101 Thunderbird/31.4.0
MIME-Version: 1.0
To: Victor Kamensky <victor.kamensky@linaro.org>
CC: Arnaldo Carvalho de Melo <acme@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        Adrian Hunter <adrian.hunter@intel.com>, Jiri Olsa <jolsa@redhat.com>,
        Avi Kivity <avi@cloudius-systems.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Anton Blanchard <anton@samba.org>, Will Deacon <will.deacon@arm.com>,
        Dave Martin <Dave.Martin@arm.com>,
        open list <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Jiri Olsa <jolsa@kernel.org>, Waiman Long <Waiman.Long@hp.com>
Subject: Re: [PATCH 2/2] perf symbols: debuglink should take symfs option
 into account
References: <1421168344-5363-1-git-send-email-victor.kamensky@linaro.org>	<1421168344-5363-2-git-send-email-victor.kamensky@linaro.org>	<CAA3XUr1BnS=8RTVyxtVOm4Ahb2DQXUuJJQC1w2SvT5fycjRcEQ@mail.gmail.com>	<54C0216F.3080404@gmail.com>	<CAA3XUr0uXykCTVuw-sYmkhsFZ-cimeuJkXTXNdJyhJh7976xEQ@mail.gmail.com>	<54C04A1B.8040408@gmail.com> <CAA3XUr3RJ1RbYTOh2SczZdkGgrk6f=VfoDzu6SQXVu_XwC+FLg@mail.gmail.com>
In-Reply-To: <CAA3XUr3RJ1RbYTOh2SczZdkGgrk6f=VfoDzu6SQXVu_XwC+FLg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 1/21/15 6:32 PM, Victor Kamensky wrote:
> May I use 'Acked-by' (maybe 'Tested-by' as well) with
> your name for the shorter (no filename_copy) as above
> version of the patch for .gnu_debuglink issue fix.

You can add both to your second patch -- the short version.

Acked-and-Tested-by: David Ahern <dsahern@gmail.com>
