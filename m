Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751233AbaB0J0k (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 04:26:40 -0500
Received: from mx1.redhat.com ([209.132.183.28]:65371 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750957AbaB0J0i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 04:26:38 -0500
Message-ID: <530F04BD.2060403@redhat.com>
Date: Thu, 27 Feb 2014 10:26:21 +0100
From: Daniel Borkmann <dborkman@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Jan Beulich <JBeulich@suse.com>
CC: mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com, davem@davemloft.net,
        ffusco@redhat.com, tgraf@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/3] x86/hash: fix build failure with older binutils
References: <530F0996020000780011FBE7@nat28.tlf.novell.com>
In-Reply-To: <530F0996020000780011FBE7@nat28.tlf.novell.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/27/2014 09:47 AM, Jan Beulich wrote:
> Just like for other ISA extension instruction uses we should check
> whether the assembler actually supports them. The fallback here simply
> is to encode an instruction  with fixed operands (%eax and %ecx).
>
> Signed-off-by: Jan Beulich <jbeulich@suse.com>
> Cc: Francesco Fusco <ffusco@redhat.com>
> Cc: Daniel Borkmann <dborkman@redhat.com>
> Cc: Thomas Graf <tgraf@redhat.com>
> Cc: David S. Miller <davem@davemloft.net>

Acked-by: Daniel Borkmann <dborkman@redhat.com>
