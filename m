Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751421AbaKFPlP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 10:41:15 -0500
Received: from mail.skyhub.de ([78.46.96.112]:38110 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751021AbaKFPlM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 10:41:12 -0500
Date: Thu, 6 Nov 2014 16:41:10 +0100
From: Borislav Petkov <bp@alien8.de>
To: Chen Yucong <slaoub@gmail.com>
Cc: Tony Luck <tony.luck@gmail.com>, Andi Kleen <ak@linux.intel.com>,
        aravind.gopalakrishnan@amd.com,
        Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2 v2] x86, mce, severity: extend the the mce_severity
Message-ID: <20141106154109.GD4318@pd.tnic>
References: <1415162873-1874-1-git-send-email-slaoub@gmail.com>
 <1415162873-1874-2-git-send-email-slaoub@gmail.com>
 <CA+8MBb+72pZfDke3ZVfY+Vtjqd63wx4qnccKP6H8UiSQrORJSA@mail.gmail.com>
 <1415238859.2840.22.camel@debian>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1415238859.2840.22.camel@debian>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 06, 2014 at 09:54:19AM +0800, Chen Yucong wrote:
> If `no_way_out' equals 1, we may need to dump/decode corrected/deferred 
> error information. So if we use "NOEXCP" to initialize the deferred and
> UCNA table entries, do_machine_check will skip checking deferred/UCNA
> entry when `no_way_out' is set to 1.

I think we want to log every error when we're panicking, even the
deferred ones.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
