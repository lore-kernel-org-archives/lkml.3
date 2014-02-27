Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753777AbaB0SxZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 13:53:25 -0500
Received: from terminus.zytor.com ([198.137.202.10]:58474 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753052AbaB0SxY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 13:53:24 -0500
Message-ID: <530F898B.5090400@zytor.com>
Date: Thu, 27 Feb 2014 10:52:59 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Jan Beulich <JBeulich@suse.com>, mingo@elte.hu, tglx@linutronix.de
CC: davem@davemloft.net, dborkman@redhat.com, ffusco@redhat.com,
        tgraf@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/3] x86/hash: swap arguments passed to crc32_u32()
References: <530F09B6020000780011FBEB@nat28.tlf.novell.com>
In-Reply-To: <530F09B6020000780011FBEB@nat28.tlf.novell.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/27/2014 12:47 AM, Jan Beulich wrote:
> ... to match the function's parameters. While reportedly commutative,
> using the proper order allows for leveraging the instruction permitting
> the source operand to be in memory.
> 
> Signed-off-by: Jan Beulich <jbeulich@suse.com>
> Acked-by: Daniel Borkmann <dborkman@redhat.com>
> Cc: Francesco Fusco <ffusco@redhat.com>
> Cc: Thomas Graf <tgraf@redhat.com>
> Cc: David S. Miller <davem@davemloft.net>

Acked-by: H. Peter Anvin <hpa@zytor.com>

