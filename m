Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754447AbaDONFL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 09:05:11 -0400
Received: from e06smtp12.uk.ibm.com ([195.75.94.108]:51543 "EHLO
	e06smtp12.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751312AbaDONFI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 09:05:08 -0400
Message-ID: <534D2E7E.4090904@de.ibm.com>
Date: Tue, 15 Apr 2014 15:05:02 +0200
From: Christian Borntraeger <borntraeger@de.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Ingo Molnar <mingo@redhat.com>, Arnaldo Carvalho de Melo <acme@redhat.com>
CC: linux-kernel@vger.kernel.org, KVM <kvm@vger.kernel.org>,
        Alexander Yarygin <yarygin@linux.vnet.ibm.com>, jolsa@redhat.com,
        dsahern@gmail.com
Subject: Re: [PULL 0/2] small perf fixes
References: <1397053319-2130-1-git-send-email-borntraeger@de.ibm.com>
In-Reply-To: <1397053319-2130-1-git-send-email-borntraeger@de.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14041513-8372-0000-0000-0000095B2F97
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/04/14 16:21, Christian Borntraeger wrote:
> Ingo, Arnaldo,
> 
> two fixes indentified during kvm on s390 development are available 
> 
> since commit 538592ff0b008237ae88f5ce5fb1247127dc3ce5:
> 
>   Merge tag 'perf-core-for-mingo' of git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux into perf/core (2014-03-19 08:05:47 +0100)
> 
> in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/kvms390/linux.git tags/perf-fixes
> 
> for you to fetch changes up to 5e032c6c3eaf499460e3ca6b9586c7605c16004e:
> 
>   perf-kvm: fix of 'Min time' counting in report command (2014-04-09 16:06:15 +0200)
> 
> Please consider to apply.
> 
> ----------------------------------------------------------------
> Provide two fixes for perf:
> - allow "-" in trace names. This enables perf to also handle kvm-s390
> - fix min accounting in for perf kvm
> 
> ----------------------------------------------------------------
> Alexander Yarygin (2):
>       perf/tool: Fix usage of trace events with '-' in trace system name.
>       perf-kvm: fix of 'Min time' counting in report command
> 
>  tools/perf/builtin-kvm.c       |    1 +
>  tools/perf/util/parse-events.l |    2 +-
>  2 files changed, 2 insertions(+), 1 deletion(-)
> 

Ping.


