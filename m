Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754392Ab3ILI0f (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 04:26:35 -0400
Received: from mx1.redhat.com ([209.132.183.28]:25179 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751201Ab3ILI0c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 04:26:32 -0400
Date: Thu, 12 Sep 2013 11:28:35 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
Cc: Gleb Natapov <gleb@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, Rob Landley <rob@landley.net>,
        mtosatti@redhat.com
Subject: Re: [PATCH V3] Documentation/kvm: Update cpuid documentation for
 steal  time and pv eoi
Message-ID: <20130912082835.GA18836@redhat.com>
References: <y>
 <1378971011-25774-1-git-send-email-raghavendra.kt@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1378971011-25774-1-git-send-email-raghavendra.kt@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 12, 2013 at 01:00:11PM +0530, Raghavendra K T wrote:
> Thanks Michael S Tsirkin for rewriting the description and suggestions.
> 
> Signed-off-by: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>


Acked-by: Michael S. Tsirkin <mst@redhat.com>

> ---
> 
>  Changes in V3:
>   Keep msr specific info only as suggested by Michael. 
> 
>  Documentation/virtual/kvm/cpuid.txt | 7 +++++++
>  1 file changed, 7 insertions(+)
> 
> diff --git a/Documentation/virtual/kvm/cpuid.txt b/Documentation/virtual/kvm/cpuid.txt
> index 22ff659..3c65feb 100644
> --- a/Documentation/virtual/kvm/cpuid.txt
> +++ b/Documentation/virtual/kvm/cpuid.txt
> @@ -43,6 +43,13 @@ KVM_FEATURE_CLOCKSOURCE2           ||     3 || kvmclock available at msrs
>  KVM_FEATURE_ASYNC_PF               ||     4 || async pf can be enabled by
>                                     ||       || writing to msr 0x4b564d02
>  ------------------------------------------------------------------------------
> +KVM_FEATURE_STEAL_TIME             ||     5 || steal time can be enabled by
> +                                   ||       || writing to msr 0x4b564d03.
> +------------------------------------------------------------------------------
> +KVM_FEATURE_PV_EOI                 ||     6 || paravirtualized end of interrupt
> +                                   ||       || handler can be enabled by writing
> +                                   ||       || to msr 0x4b564d04.
> +------------------------------------------------------------------------------
>  KVM_FEATURE_PV_UNHALT              ||     7 || guest checks this feature bit
>                                     ||       || before enabling paravirtualized
>                                     ||       || spinlock support.
> -- 
> 1.7.11.7
