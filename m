Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755464Ab3L1RCE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Dec 2013 12:02:04 -0500
Received: from terminus.zytor.com ([198.137.202.10]:35808 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755301Ab3L1RCC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Dec 2013 12:02:02 -0500
Message-ID: <52BF03D8.7000309@zytor.com>
Date: Sat, 28 Dec 2013 09:01:12 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Christoph Hellwig <hch@infradead.org>, "H.J. Lu" <hjl.tools@gmail.com>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/8] Update kernel uabi header files for x32
References: <1388182464-28428-1-git-send-email-hjl.tools@gmail.com> <20131228163308.GA1638@infradead.org>
In-Reply-To: <20131228163308.GA1638@infradead.org>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/28/2013 08:33 AM, Christoph Hellwig wrote:
> 
> Independent on how this fixes things, how does the kernel_long_t name
> here make any sense?
> 
> On x86-64 "kernel" long always is 64 bits wide.  The userspace ABI long
> might be 32 or 64bits wide.
> 
> Currently kernel_long_t has almost no uses, so it might be a good time
> to fix the name, define the rules for it, and last but not least
> properly document the intent for thse types.
> 

The definition is "an integer type the same width as 'long' for the
native kernel type for the ABI".  If you have any suggestions for a
better name, or for that matter, a better alternative, that would be
genuinely appreciated...

	-hpa

