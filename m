Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753651AbaJTVmL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2014 17:42:11 -0400
Received: from terminus.zytor.com ([198.137.202.10]:42736 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753211AbaJTVmK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2014 17:42:10 -0400
Message-ID: <54458199.1000607@zytor.com>
Date: Mon, 20 Oct 2014 14:41:45 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Andy Lutomirski <luto@amacapital.net>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        x86@kernel.org
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/8] x86: Disentangle the vdso and clean it up
References: <cover.1411494540.git.luto@amacapital.net>
In-Reply-To: <cover.1411494540.git.luto@amacapital.net>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/23/2014 10:50 AM, Andy Lutomirski wrote:
> 
> Patch 8 removes the vvar that selects the getcpu mode.  That vvar
> has been unnecessary for a couple of years, ever since alternative
> patching has worked in the vdso.
> 

Is there any fundamental reason to not always use LSL at this point?

	-hpa


