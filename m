Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752956Ab3H0IDS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Aug 2013 04:03:18 -0400
Received: from lgeamrelo01.lge.com ([156.147.1.125]:55918 "EHLO
	LGEAMRELO01.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752551Ab3H0IDP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Aug 2013 04:03:15 -0400
X-AuditID: 9c93017d-b7cdfae0000026c0-d5-521c5d41067a
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Pekka Enberg <penberg@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/3] perf ui/gtk: Separate out GTK code to a shared object (v4)
References: <1376029689-32593-1-git-send-email-namhyung@kernel.org>
	<20130819140500.GA3053@ghostprotocols.net>
	<20130819151734.GB3053@ghostprotocols.net>
Date: Tue, 27 Aug 2013 17:03:12 +0900
In-Reply-To: <20130819151734.GB3053@ghostprotocols.net> (Arnaldo Carvalho de
	Melo's message of "Mon, 19 Aug 2013 12:17:34 -0300")
Message-ID: <87r4dfv9vj.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnaldo,

Sorry for late reply.

On Mon, 19 Aug 2013 12:17:34 -0300, Arnaldo Carvalho de Melo wrote:
> Em Mon, Aug 19, 2013 at 11:05:00AM -0300, Arnaldo Carvalho de Melo escreveu:
>> But I expected that after the first patch 'perf --gtk' would work, and
>> it doesn't.
>> 
>> Now even after I applied the whole series I don't get --gtk to work,
>> neither as a non-root nor as root :-\
>> 
>> Investigating...
>
> Somehow I expected ~/lib64/ was in the ld library path, it was not, duh,
> after I added it, and applied all three patches, it works as expected,
> so can we:
>
> 1. combine the three patches into just one so that we keep the 'perf
> report --gtk' bisectable?
>
> 2. add a patch to warn the user when '--gtk' is specified but no
>    libperf-gtk.so file is found in the loader library path?

Hmm.. makes sense.  I'll do the option 1 (include the warning).

Thanks,
Namhyung
