Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758115Ab3ANUqR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2013 15:46:17 -0500
Received: from terminus.zytor.com ([198.137.202.10]:58143 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756777Ab3ANUqQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2013 15:46:16 -0500
Message-ID: <50F46E77.4070500@zytor.com>
Date: Mon, 14 Jan 2013 12:45:43 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Borislav Petkov <bp@alien8.de>, Jan Kiszka <jan.kiszka@web.de>,
        Jason Wessel <jason.wessel@windriver.com>,
        linux-kernel@vger.kernel.org, David Woodhouse <dwmw2@infradead.org>
Subject: Re: [PATCH v7u1 00/31] x86, boot, 64bit: Add support for loading
 ramdisk and bzImage above 4G
References: <1357260531-11115-1-git-send-email-yinghai@kernel.org>
In-Reply-To: <1357260531-11115-1-git-send-email-yinghai@kernel.org>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is getting extremely unwieldy and we need to get it broken up a bit.

I would really like to get the boot protocol changes earlier in the
series, because it has interactions with work other people are doing and
may need additional surgery.  That is, the additions of flags and fields
to make it possible for the kernel to indicate that > 4 GB booting is
possible, not the actual implementation thereof.  This split between
protocol changes and implementation will also be useful for bisection.

	-hpa

