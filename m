Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752577AbaBXNWK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 08:22:10 -0500
Received: from terminus.zytor.com ([198.137.202.10]:34686 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752240AbaBXNWI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 08:22:08 -0500
Message-ID: <530B4767.9010109@zytor.com>
Date: Mon, 24 Feb 2014 05:21:43 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        "David E. Box" <david.e.box@linux.intel.com>
CC: tglx@linutronix.de, mingo@redhat.com, x86@kernel.org,
        linux-kernel@vger.kernel.org, srinivas.pandruvada@linux.intel.com,
        jacob.jun.pan@intel.com
Subject: Re: [PATCH RESEND] x86: iosf_mbi: Provide dummy functions if CONFIG_IOSF_MBI
 not set
References: <1392248063-16389-1-git-send-email-david.e.box@linux.intel.com>	<1393117352-23717-1-git-send-email-david.e.box@linux.intel.com> <20140224131902.30983051@alan.etchedpixels.co.uk>
In-Reply-To: <20140224131902.30983051@alan.etchedpixels.co.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/24/2014 05:19 AM, One Thousand Gnomes wrote:
>
> Other than _available I would have expected all the others to resolve to
> returning an error or doing a WARN() in the not compiled in case.
>

WARN() or BUG()?

	-hpa


