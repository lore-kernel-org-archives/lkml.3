Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754569AbaB0D0h (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 22:26:37 -0500
Received: from terminus.zytor.com ([198.137.202.10]:48922 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753117AbaB0D0f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 22:26:35 -0500
Message-ID: <530EB05C.8060803@zytor.com>
Date: Wed, 26 Feb 2014 19:26:20 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: "David E. Box" <david.e.box@linux.intel.com>, tglx@linutronix.de,
        mingo@redhat.com
CC: x86@kernel.org, linux-kernel@vger.kernel.org,
        srinivas.pandruvada@linux.intel.com, jacob.jun.pan@intel.com
Subject: Re: [PATCH V3 2/2] x86: IOSF: Change IOSF_MBI Kconfig to default
 y
References: <1393443617-8923-1-git-send-email-david.e.box@linux.intel.com> <1393443617-8923-3-git-send-email-david.e.box@linux.intel.com>
In-Reply-To: <1393443617-8923-3-git-send-email-david.e.box@linux.intel.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/26/2014 11:40 AM, David E. Box wrote:
> From: "David E. Box" <david.e.box@linux.intel.com>
> 
> The IOSF Mailbox interface is an access mechanism used by multiple drivers to
> communicate with key configuration registers on new Intel SOC platforms. The
> interface is ubiquitous enough that we need to ensure the availability of the
> driver in non-EXPERT configured x86 kernels.
> 
> Signed-off-by: David E. Box <david.e.box@linux.intel.com>

Hi David,

Could you please update the patch description to explain to people who
may not be familiar why the IOSF driver can't be a module?

	-hpa


