Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754361Ab3LCP0X (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 10:26:23 -0500
Received: from mx1.redhat.com ([209.132.183.28]:11363 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753246Ab3LCP0V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 10:26:21 -0500
Date: Tue, 3 Dec 2013 10:25:36 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
Cc: "H. Peter Anvin" <hpa@linux.intel.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Fengguang Wu <fengguang.wu@intel.com>, Borislav Petkov <bp@alien8.de>,
        "kexec@lists.infradead.org" <kexec@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Jingbai Ma <jingbai.ma@hp.com>, Jerry Hoemann <jerry.hoemann@hp.com>
Subject: Re: [PATCH v9] x86, apic, kexec, Documentation: Add disable_cpu_apic
 kernel parameter
Message-ID: <20131203152536.GE4251@redhat.com>
References: <529D34AA.1000809@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <529D34AA.1000809@jp.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 03, 2013 at 10:32:26AM +0900, HATAYAMA Daisuke wrote:

[..]
> 
> diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
> index 50680a5..dd77bec 100644
> --- a/Documentation/kernel-parameters.txt
> +++ b/Documentation/kernel-parameters.txt
> @@ -774,6 +774,15 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
>  	disable=	[IPV6]
>  			See Documentation/networking/ipv6.txt.
>  
> +	disable_cpu_apicid= [X86,APIC,KEXEC,SMP]

Hi Hatayama, 

We are almost there. A minor nit. Why have we specified KEXEC here. This
parameter disabled_cpu_apicid does not seem to dependon CONFIG_KEXEC?

Jerry, this patch looks good to me. Does it work on your system?

Thanks
Vivek
