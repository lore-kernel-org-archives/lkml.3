Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756098Ab3L2CiG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Dec 2013 21:38:06 -0500
Received: from terminus.zytor.com ([198.137.202.10]:39677 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753427Ab3L2CiD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Dec 2013 21:38:03 -0500
Message-ID: <52BF8AEE.6020904@zytor.com>
Date: Sat, 28 Dec 2013 18:37:34 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: halfdog <me@halfdog.net>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>
CC: x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Sanitize CPU-state when switching from virtual-8086 mode to other
 task
References: <52BF4A80.3010503@halfdog.net>
In-Reply-To: <52BF4A80.3010503@halfdog.net>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/28/2013 02:02 PM, halfdog wrote:
> It seems that missing CPU-state sanitation during task switching 
> triggers kernel-panic. This might be related to unhandled
> FPU-errors. See [1] for POC and serial console log of OOPs. Due to
> missing real 32-bit x86-hardware it is not clear, if this issue
> might be related to subtle differences in virtual-8086 mode
> handling when inside a virtualbox guest.
> 

This oops happens inside the guest?  Either way, I would be *very*
skeptical of Virtualbox in this case.

You can run a 32-bit kernel on 64-bit hardware, you know...

	-hpa
