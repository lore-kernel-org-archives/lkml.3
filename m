Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758135AbaAJVkB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jan 2014 16:40:01 -0500
Received: from g4t0017.houston.hp.com ([15.201.24.20]:12211 "EHLO
	g4t0017.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757951AbaAJVj6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jan 2014 16:39:58 -0500
Message-ID: <1389389641.1792.173.camel@misato.fc.hp.com>
Subject: Re: [PATCH 1/2] acpi memory hotplug, add parameter to disable
 memory hotplug [v2]
From: Toshi Kani <toshi.kani@hp.com>
To: Prarit Bhargava <prarit@redhat.com>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        x86@kernel.org, Len Brown <lenb@kernel.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>, Linn Crosetto <linn@hp.com>,
        Pekka Enberg <penberg@kernel.org>, Yinghai Lu <yinghai@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Tang Chen <tangchen@cn.fujitsu.com>,
        Wen Congyang <wency@cn.fujitsu.com>, Vivek Goyal <vgoyal@redhat.com>,
        kosaki.motohiro@gmail.com, dyoung@redhat.com,
        linux-acpi@vger.kernel.org, linux-mm@kvack.org
Date: Fri, 10 Jan 2014 14:34:01 -0700
In-Reply-To: <1389380698-19361-3-git-send-email-prarit@redhat.com>
References: <1389380698-19361-1-git-send-email-prarit@redhat.com>
	 <1389380698-19361-3-git-send-email-prarit@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.5 (3.8.5-2.fc19) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-01-10 at 14:04 -0500, Prarit Bhargava wrote:
 :
> ---
>  Documentation/kernel-parameters.txt |    3 +++
>  drivers/acpi/acpi_memhotplug.c      |   12 ++++++++++++
>  2 files changed, 15 insertions(+)
> 
> diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
> index b9e9bd8..41374f9 100644
> --- a/Documentation/kernel-parameters.txt
> +++ b/Documentation/kernel-parameters.txt
> @@ -2117,6 +2117,9 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
>  
>  	nomce		[X86-32] Machine Check Exception
>  
> +	acpi_no_memhotplug [ACPI] Disable memory hotplug.  Useful for kexec
> +			   and kdump kernels.
> +

Please move it to where other acpi_xxx are described.

For kdump kernel, this option will be used when memmap=exactmap is
deprecated.  IOW, it is not useful yet.  Not sure what you mean by kexec
kernel.  Memory hotplug does not need to be disabled for kexec reboot.

Thanks,
-Toshi



