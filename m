Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752511AbaF0FkI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2014 01:40:08 -0400
Received: from terminus.zytor.com ([198.137.202.10]:38347 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750729AbaF0FkH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2014 01:40:07 -0400
Message-ID: <53AD0376.3040200@zytor.com>
Date: Thu, 26 Jun 2014 22:39:02 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Oren Twaig <oren@scalemp.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, David Rientjes <rientjes@google.com>,
        Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Jan Kiszka <jan.kiszka@siemens.com>, Andi Kleen <ak@linux.intel.com>,
        HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>,
        Richard Weinberger <richard@nod.at>
CC: x86@kernel.org, linux-kernel@vger.kernel.org,
        Shai Fultheim <shai@scalemp.com>
Subject: Re: [PATCH] x86, vsmp: Remove is_vsmp_box() from apic_is_clustered_box()
References: <53A7BC92.3080307@scalemp.com> <53ACFB90.7030608@scalemp.com>
In-Reply-To: <53ACFB90.7030608@scalemp.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/26/2014 10:05 PM, Oren Twaig wrote:
> ping

This patch conflicts with the changes on the tip:x86/apic branch.  Could
you please rebase the patch on top of that branch?

	-hpa


