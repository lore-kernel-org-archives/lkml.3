Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752758AbaINNYr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Sep 2014 09:24:47 -0400
Received: from mx1.redhat.com ([209.132.183.28]:2589 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752594AbaINNYq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Sep 2014 09:24:46 -0400
Date: Sun, 14 Sep 2014 15:23:51 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: peterz@infradead.org, linux-kernel@vger.kernel.org, mingo@kernel.org,
        eranian@google.com, Andi Kleen <ak@linux.intel.com>,
        Vince Weaver <vincent.weaver@maine.edu>
Subject: Re: [PATCH] Add some documentation on the perf sysfs ABI interface
Message-ID: <20140914132351.GD1731@krava.redhat.com>
References: <1410561259-523-1-git-send-email-andi@firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1410561259-523-1-git-send-email-andi@firstfloor.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 12, 2014 at 03:34:19PM -0700, Andi Kleen wrote:
> From: Andi Kleen <ak@linux.intel.com>
> 
> Initial attempt of documenting the perf sysfs interface as
> an ABI. I also added some additional pointers hopefully useful
> to the users. Comments welcome.
> 
> Cc: Vince Weaver <vincent.weaver@maine.edu>
> Cc: jolsa@redhat.com
> v2: Various fixes. Fix cmask/inv (Stephane) Fixes from Randy Dunlap.
> Signed-off-by: Andi Kleen <ak@linux.intel.com>
> ---
>  Documentation/ABI/stable/sysfs-devices-perf | 98 +++++++++++++++++++++++++++++
>  1 file changed, 98 insertions(+)
>  create mode 100644 Documentation/ABI/stable/sysfs-devices-perf
> 
> diff --git a/Documentation/ABI/stable/sysfs-devices-perf b/Documentation/ABI/stable/sysfs-devices-perf
> new file mode 100644
> index 0000000..3fd9bc6
> --- /dev/null
> +++ b/Documentation/ABI/stable/sysfs-devices-perf
> @@ -0,0 +1,98 @@
> +Perf events enumeration in sysfs
> +
> +The perf events subsystem exports the format of hardware performance
> +counter events supported by perf events. The events can be accessed
> +using the perf_event_open() syscall. Each perf directory in devices
> +represents a distinct PMU (Performance Monitoring Unit), but not all
> +directories in this file are perf directories.

s/in this file/in this directory/ ?

otherwise it looks ok to me

jirka
