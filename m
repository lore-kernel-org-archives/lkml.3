Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753411Ab3ILFPr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 01:15:47 -0400
Received: from e28smtp01.in.ibm.com ([122.248.162.1]:43668 "EHLO
	e28smtp01.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752999Ab3ILFPo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 01:15:44 -0400
Message-ID: <52314F63.8040409@linux.vnet.ibm.com>
Date: Thu, 12 Sep 2013 10:51:39 +0530
From: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
Organization: IBM
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>,
        "Michael S. Tsirkin" <mst@redhat.com>
CC: Gleb Natapov <gleb@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, Rob Landley <rob@landley.net>,
        mtosatti@redhat.com
Subject: Re: [PATCH V2] Documentation/kvm: Update cpuid documentation for
 steal time and pv eoi
References: <y> <1378284526-863-1-git-send-email-raghavendra.kt@linux.vnet.ibm.com>
In-Reply-To: <1378284526-863-1-git-send-email-raghavendra.kt@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13091205-4790-0000-0000-00000A45FBA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/04/2013 02:18 PM, Raghavendra K T wrote:
> Signed-off-by: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
> ---
>   Changes in V2:
>    Correction in the description of steal time and added msr info (Michael S Tsirkin)
>
>   Documentation/virtual/kvm/cpuid.txt | 10 ++++++++++
>   1 file changed, 10 insertions(+)
>
> diff --git a/Documentation/virtual/kvm/cpuid.txt b/Documentation/virtual/kvm/cpuid.txt
> index 22ff659..6c4fb20 100644
> --- a/Documentation/virtual/kvm/cpuid.txt
> +++ b/Documentation/virtual/kvm/cpuid.txt
> @@ -43,6 +43,16 @@ KVM_FEATURE_CLOCKSOURCE2           ||     3 || kvmclock available at msrs
>   KVM_FEATURE_ASYNC_PF               ||     4 || async pf can be enabled by
>                                      ||       || writing to msr 0x4b564d02
>   ------------------------------------------------------------------------------
> +KVM_FEATURE_STEAL_TIME             ||     5 || Steal time available at msr
> +                                   ||       || 0x4b564d03. The feature is enabled
> +                                   ||       || by guest when host has schedstat
> +                                   ||       || or task delay accounting support.
> +------------------------------------------------------------------------------
> +KVM_FEATURE_PV_EOI                 ||     6 || overrides the generic EOI
> +                                   ||       || implementation with a
> +                                   ||       || paravirtualized version. Available
> +                                   ||       || at msr 0x4b564d04.
> +------------------------------------------------------------------------------
>   KVM_FEATURE_PV_UNHALT              ||     7 || guest checks this feature bit
>                                      ||       || before enabling paravirtualized
>                                      ||       || spinlock support.
>

Michael,

Are you okay with the above patch. Please let me know.

