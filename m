Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751766Ab3KSEiY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Nov 2013 23:38:24 -0500
Received: from terminus.zytor.com ([198.137.202.10]:42687 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751628Ab3KSEiW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Nov 2013 23:38:22 -0500
Message-ID: <528AEB27.2070404@zytor.com>
Date: Mon, 18 Nov 2013 20:37:59 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>
CC: Peter Anvin <hpa@linux.intel.com>, tglx@linutronix.de,
        linux-tip-commits@vger.kernel.org, fenghua.yu@intel.com,
        linux-kernel@vger.kernel.org
Subject: Re: [tip:x86/asm] x86-64, copy_user: Remove zero byte check before
 copy user buffer.
References: <1384634221-6006-1-git-send-email-fenghua.yu@intel.com>	<tip-f4cb1cc18f364d761d5614eb6293cccc6647f259@git.kernel.org> <CA+55aFyFz_6oy8-1jb5Jzk+4VC5MLA5d0KbqhZxki0=+DmggBg@mail.gmail.com>
In-Reply-To: <CA+55aFyFz_6oy8-1jb5Jzk+4VC5MLA5d0KbqhZxki0=+DmggBg@mail.gmail.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/16/2013 10:44 PM, Linus Torvalds wrote:
> So this doesn't do the 32-bit truncation in the error path of the generic
> string copy. Oversight?
> 
>        Linus

Hi Linus,

Do you have a preference:

1. Considering the 32-bit truncation incidental (take it or leave it);
2. Require the 32-bit truncation, or
3. Get rid of it completely?

	-hpa


