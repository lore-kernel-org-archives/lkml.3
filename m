Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751445AbaBZAjL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 19:39:11 -0500
Received: from terminus.zytor.com ([198.137.202.10]:33965 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750780AbaBZAjI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 19:39:08 -0500
Message-ID: <530D3790.301@zytor.com>
Date: Tue, 25 Feb 2014 16:38:40 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Kees Cook <keescook@chromium.org>, linux-kernel@vger.kernel.org
CC: Andrew Morton <akpm@linux-foundation.org>, Rob Landley <rob@landley.net>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        x86@kernel.org, Jianguo Wu <wujianguo@huawei.com>,
        Andy Honig <ahonig@google.com>, David Rientjes <rientjes@google.com>,
        linux-doc@vger.kernel.org
Subject: Re: [PATCH v2] x86, kaslr: randomize module base load address
References: <20140226003403.GA26737@www.outflux.net>
In-Reply-To: <20140226003403.GA26737@www.outflux.net>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/25/2014 04:34 PM, Kees Cook wrote:
> Randomize the load address of modules in the kernel to make kASLR
> effective for modules.  Modules can only be loaded within a particular
> range of virtual address space.  This patch adds 10 bits of entropy to
> the load address by adding 1-1024 * PAGE_SIZE to the beginning range
> where modules are loaded.

So the question still remains: why not randomize for each module?

	-hpa


