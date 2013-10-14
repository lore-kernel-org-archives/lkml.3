Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757170Ab3JNQaD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 12:30:03 -0400
Received: from terminus.zytor.com ([198.137.202.10]:54820 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756227Ab3JNQaB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 12:30:01 -0400
Message-ID: <525C1BC1.6090501@zytor.com>
Date: Mon, 14 Oct 2013 09:28:49 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org,
        keescook@chromium.org, md@google.com, tglx@linutronix.de,
        hpa@linux.intel.com
CC: linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/kaslr] x86, relocs: Add more per-cpu gold special cases
References: <20131011013954.GA28902@www.outflux.net> <tip-d751c169e9a6f0f853346f1184881422bd10b3c2@git.kernel.org> <20131014083035.GA20976@gmail.com> <007cdb12-9fc7-4744-8686-695891b926a3@email.android.com>
In-Reply-To: <007cdb12-9fc7-4744-8686-695891b926a3@email.android.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/14/2013 07:19 AM, H. Peter Anvin wrote:
> My guess is that the 95 addresses are randomized and the 82 address is an address which failed to relocate.

> ffffffff82a04a58 is:
> ffffffff82a03000 t init_per_cpu__gdt_page


Specifically, it looks like the percpu stuff isn't getting set up correctly.

	-hpa

