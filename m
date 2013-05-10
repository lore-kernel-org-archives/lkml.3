Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757827Ab3EJB54 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 May 2013 21:57:56 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:49498 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757648Ab3EJB5z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 May 2013 21:57:55 -0400
X-AuditID: 9c930197-b7c1fae000001854-7d-518c54215c2e
From: Namhyung Kim <namhyung@kernel.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: linux-kernel@vger.kernel.org, Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Andi Kleen <ak@linux.intel.com>, David Ahern <dsahern@gmail.com>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 8/9] perf: Document the ABI for 'precise' sysfs attribute
References: <1368106344-23383-1-git-send-email-jolsa@redhat.com>
	<1368106344-23383-9-git-send-email-jolsa@redhat.com>
Date: Fri, 10 May 2013 10:57:53 +0900
In-Reply-To: <1368106344-23383-9-git-send-email-jolsa@redhat.com> (Jiri Olsa's
	message of "Thu, 9 May 2013 15:32:23 +0200")
Message-ID: <87y5bn61ge.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu,  9 May 2013 15:32:23 +0200, Jiri Olsa wrote:
> Adding ABI documentation for newly added 'precise' sysfs
> attribute.  It's added under the testing section.
>
> Signed-off-by: Jiri Olsa <jolsa@redhat.com>
> Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
> Cc: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: Ingo Molnar <mingo@elte.hu>
> Cc: Namhyung Kim <namhyung@kernel.org>
> Cc: Paul Mackerras <paulus@samba.org>
> Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
> Cc: Andi Kleen <ak@linux.intel.com>
> Cc: David Ahern <dsahern@gmail.com>
> Cc: Stephane Eranian <eranian@google.com>
> ---
>  .../ABI/testing/sysfs-bus-event_source-devices-cpu-precise     | 10 ++++++++++
>  1 file changed, 10 insertions(+)
>  create mode 100644 Documentation/ABI/testing/sysfs-bus-event_source-devices-cpu-precise
>
> diff --git a/Documentation/ABI/testing/sysfs-bus-event_source-devices-cpu-precise b/Documentation/ABI/testing/sysfs-bus-event_source-devices-cpu-precise
> new file mode 100644
> index 0000000..f3ed378
> --- /dev/null
> +++ b/Documentation/ABI/testing/sysfs-bus-event_source-devices-cpu-precise
> @@ -0,0 +1,10 @@
> +Where:		/sys/bus/event_source/devices/cpu/precise
> +Date:		January 2013
> +Kernel Version:	3.7

Looks like a copy-and-paste problem. :)

Thanks,
Namhyung


> +Contact:	Jiri Olsa <jolsa@redhat.com>
> +		Linux kernel mailing list <linux-kernel@vger.kernel.org>
> +Description:
> +		X86 specific attribute
> +
> +		Attribute to specify the maximum allowed value
> +		for perf_event_attr:precise_ip field.
