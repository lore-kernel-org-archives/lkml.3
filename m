Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753533Ab3JXGKH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Oct 2013 02:10:07 -0400
Received: from mailout2.zih.tu-dresden.de ([141.30.67.73]:46748 "EHLO
	mailout2.zih.tu-dresden.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751553Ab3JXGKF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Oct 2013 02:10:05 -0400
Message-ID: <5268B9B6.40809@tu-dresden.de>
Date: Thu, 24 Oct 2013 08:09:58 +0200
From: Joseph Schuchart <joseph.schuchart@tu-dresden.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@redhat.com>, thomas.ilsche@tu-dresden.de,
        linux-kernel@vger.kernel.org,
        Tom Zanussi <tom.zanussi@linux.intel.com>
Subject: Re: Perf Python Scripting Leaks Memory
References: <5267DF35.5010706@tu-dresden.de> <20131023200149.GA6539@ghostprotocols.net>
In-Reply-To: <20131023200149.GA6539@ghostprotocols.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TUD-Virus-Scanned: mailout2.zih.tu-dresden.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 23.10.2013 22:01, Arnaldo Carvalho de Melo wrote:
> Em Wed, Oct 23, 2013 at 04:37:41PM +0200, Joseph Schuchart escreveu:
>>    We are using the Python scripting interface in perf to extract kernel
>>    events relevant for performance analysis of HPC codes. We noticed that the
>>    "perf script" call allocates a significant amount of memory (in the order
>>    of several 100 MiB) during it's run, e.g. 125 MiB for a 25 MiB input file:
> 
> Thanks for the analysis and the bug fix!
> 
> I asked Tom Zanussi and he kindly reviewed your patch and provided an
> Acked-by tag for it, Tom, may I add a Reviewed-by: as well?
> 
> Joseph, can I have your Signed-off-by: tag, as documented in:
> 
> Documentation/SubmittingPatches
> 

Thanks for your quick reply and sorry for not following the
recommendations in the documentation.

Signed-off-by: Joseph Schuchart <joseph.schuchart@tu-dresden.de>

Thanks!
Joseph
