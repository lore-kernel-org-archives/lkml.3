Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758106Ab3ANSnZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2013 13:43:25 -0500
Received: from terminus.zytor.com ([198.137.202.10]:56396 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757165Ab3ANSnW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2013 13:43:22 -0500
Message-ID: <50F451A5.7040909@zytor.com>
Date: Mon, 14 Jan 2013 10:42:45 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>, Yinghai Lu <yinghai@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jan Kiszka <jan.kiszka@web.de>,
        Jason Wessel <jason.wessel@windriver.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v7u1 24/31] x86, boot: Not need to check setup_header
 version for setup_data
References: <1357260531-11115-1-git-send-email-yinghai@kernel.org> <1357260531-11115-25-git-send-email-yinghai@kernel.org> <20130114112619.GG1228@liondog.tnic> <50F44260.5030305@zytor.com> <20130114180423.GA6213@liondog.tnic>
In-Reply-To: <20130114180423.GA6213@liondog.tnic>
X-Enigmail-Version: 1.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/14/2013 10:04 AM, Borislav Petkov wrote:
> 
> See, this is exactly the reason why I'm trying to explain to Yinghai
> why it is a Good Thing to document stuff like that at least in commit
> messages.
> 

It very much is.  It avoids these kinds of long discussions.

	-hpa


