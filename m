Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753329AbaAQTFB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jan 2014 14:05:01 -0500
Received: from terminus.zytor.com ([198.137.202.10]:59939 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753132AbaAQTFA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jan 2014 14:05:00 -0500
Message-ID: <52D97ECA.8040301@zytor.com>
Date: Fri, 17 Jan 2014 11:04:42 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Qiaowei Ren <qiaowei.ren@intel.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@kernel.org>
CC: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/5] x86, mpx: add MPX related opcodes to the x86 opcode
 map
References: <1389518403-7715-1-git-send-email-qiaowei.ren@intel.com> <1389518403-7715-4-git-send-email-qiaowei.ren@intel.com>
In-Reply-To: <1389518403-7715-4-git-send-email-qiaowei.ren@intel.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/12/2014 01:20 AM, Qiaowei Ren wrote:
> This patch adds all the MPX instructions to x86 opcode map, and then
> the x86 instruction decoder can decode MPX instructions used in kernel.
> 
> Signed-off-by: Qiaowei Ren <qiaowei.ren@intel.com>
> ---
>  arch/x86/lib/x86-opcode-map.txt |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)

This patch seems rather trivial and uncontroversial, so I'm going to
pull it in.

	-hpa



