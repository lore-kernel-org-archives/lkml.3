Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750944Ab3EIEEX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 May 2013 00:04:23 -0400
Received: from terminus.zytor.com ([198.137.202.10]:47153 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750704Ab3EIEEW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 May 2013 00:04:22 -0400
Message-ID: <518B2033.80300@zytor.com>
Date: Wed, 08 May 2013 21:04:03 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130311 Thunderbird/17.0.4
MIME-Version: 1.0
To: Mike Frysinger <vapier@gentoo.org>
CC: x86@kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: make stat/statfs 64-bit for x86_64 kernels
References: <1368072057-7832-1-git-send-email-vapier@gentoo.org>
In-Reply-To: <1368072057-7832-1-git-send-email-vapier@gentoo.org>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/08/2013 09:00 PM, Mike Frysinger wrote:
> When including these headers in the x32 ABI, the structs get declared
> with 32bit sizes which is incorrect.  Use long long and such to make
> it work both with x32 and x86_64.
> 
> Signed-off-by: Mike Frysinger <vapier@gentoo.org>

I'm not sure if it is okay to change the types, even within the same
size.  Perhaps use __u64/__s64?

	-hpa


