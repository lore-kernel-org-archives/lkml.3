Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753572AbaACUuv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jan 2014 15:50:51 -0500
Received: from merlin.infradead.org ([205.233.59.134]:55052 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753478AbaACUuu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jan 2014 15:50:50 -0500
Message-ID: <52C722A7.5070001@infradead.org>
Date: Fri, 03 Jan 2014 12:50:47 -0800
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Ramkumar Ramachandra <artagnon@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>
CC: Dirk Brandewie <dirk.brandewie@gmail.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Linux PM <linux-pm@vger.kernel.org>
Subject: Re: [PATCH v2] Documentation/cpu-freq: add intel-pstate.txt
References: <1388777026-12227-1-git-send-email-artagnon@gmail.com>
In-Reply-To: <1388777026-12227-1-git-send-email-artagnon@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/03/14 11:23, Ramkumar Ramachandra wrote:
> 
>  Documentation/cpu-freq/intel-pstate.txt | 40 +++++++++++++++++++++++++++++++++
>  1 file changed, 40 insertions(+)
>  create mode 100644 Documentation/cpu-freq/intel-pstate.txt
> 
> diff --git a/Documentation/cpu-freq/intel-pstate.txt b/Documentation/cpu-freq/intel-pstate.txt
> new file mode 100644
> index 0000000..69bc26a
> --- /dev/null
> +++ b/Documentation/cpu-freq/intel-pstate.txt
> @@ -0,0 +1,40 @@
> +Intel P-state driver
> +--------------------
> +
> +This driver implements a scaling driver with an internal governor for
> +Intel Core processors.  The driver follows the same model as the
> +Transmeta scaling driver (longrun.c) and implements the setpolicy()
> +instead of target().  Scaling drivers that implement setpolicy() are
> +assmumed to implement internal governors by the cpufreq core. All the

   assumed

Fix that and then you can add:
Acked-by: Randy Dunlap <rdunlap@infradead.org>

Thanks.

> +logic for selecting the current P state is contained within the
> +driver; no external governor is used by the cpufreq core.
> +
> +Intel SandyBridge+ processors are supported.



-- 
~Randy
