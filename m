Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757633Ab3ANSqb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2013 13:46:31 -0500
Received: from mail.skyhub.de ([78.46.96.112]:45464 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756893Ab3ANSqa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2013 13:46:30 -0500
Date: Mon, 14 Jan 2013 19:46:16 +0100
From: Borislav Petkov <bp@alien8.de>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jan Kiszka <jan.kiszka@web.de>,
        Jason Wessel <jason.wessel@windriver.com>,
        linux-kernel@vger.kernel.org, Rob Landley <rob@landley.net>,
        Matt Fleming <matt.fleming@intel.com>
Subject: Re: [PATCH v7u1 23/31] x86, boot: update comments about entries for
 64bit image
Message-ID: <20130114184616.GB2015@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Yinghai Lu <yinghai@kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
	"H. Peter Anvin" <hpa@zytor.com>,
	"Eric W. Biederman" <ebiederm@xmission.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Jan Kiszka <jan.kiszka@web.de>,
	Jason Wessel <jason.wessel@windriver.com>,
	linux-kernel@vger.kernel.org, Rob Landley <rob@landley.net>,
	Matt Fleming <matt.fleming@intel.com>
References: <1357260531-11115-1-git-send-email-yinghai@kernel.org>
 <1357260531-11115-24-git-send-email-yinghai@kernel.org>
 <20130114112045.GF1228@liondog.tnic>
 <CAE9FiQUVkrv3jcCZnrg3=7pXyyfd9d+MJGDqU-dF_+YtB+2-ww@mail.gmail.com>
 <CAE9FiQWPbRRGkycs_oocNcHB+bEcdkqxX9zHfJVmwq_hKgKBOA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAE9FiQWPbRRGkycs_oocNcHB+bEcdkqxX9zHfJVmwq_hKgKBOA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 14, 2013 at 10:37:39AM -0800, Yinghai Lu wrote:
> also I fix some errors that you mentioned, but not all of them because
> I copied 32bit portion to 64bit and modified it.
>
> So you may submit patch to fix 32bit and 64bit at the same time if you
> like.

Sure, if they're old typos/errors. If they're new typos/errors
introduced by you, then you know that we don't commit half-baked
patches, right?

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
