Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752752AbaF2KHV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jun 2014 06:07:21 -0400
Received: from 174.37.253.146-static.reverse.softlayer.com ([174.37.253.146]:38984
	"EHLO primary.scalemp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752597AbaF2KHT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jun 2014 06:07:19 -0400
Message-ID: <53AFE551.3010406@scalemp.com>
Date: Sun, 29 Jun 2014 13:07:13 +0300
From: Oren Twaig <oren@scalemp.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, David Rientjes <rientjes@google.com>,
        Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Jan Kiszka <jan.kiszka@siemens.com>, Andi Kleen <ak@linux.intel.com>,
        HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>,
        Richard Weinberger <richard@nod.at>
CC: x86@kernel.org, linux-kernel@vger.kernel.org,
        Shai Fultheim <shai@scalemp.com>
Subject: Re: [PATCH] x86, vsmp: Remove is_vsmp_box() from apic_is_clustered_box()
References: <53A7BC92.3080307@scalemp.com> <53ACFB90.7030608@scalemp.com> <53AD0376.3040200@zytor.com>
In-Reply-To: <53AD0376.3040200@zytor.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - primary.scalemp.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - scalemp.com
X-Get-Message-Sender-Via: primary.scalemp.com: authenticated_id: oren+scalemp.com/only user confirmed/virtual account not confirmed
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

There was actually a problem that the mailer which changed a '\t' to spaces.
This is why it conflicted with the tip:x86/apic branch. Any how, I've also
tested on the x86/apic branch and everything is ok.

Sent :
"[PATCH v2] x86, vsmp: Remove is_vsmp_box() from apic_is_clustered_box()"

Sorry for any troubles.

Thanks,
Oren.

On 06/27/2014 08:39 AM, H. Peter Anvin wrote:
> On 06/26/2014 10:05 PM, Oren Twaig wrote:
>> ping
>
> This patch conflicts with the changes on the tip:x86/apic branch.  Could
> you please rebase the patch on top of that branch?
>
>     -hpa
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>


