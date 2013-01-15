Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757269Ab3AOPu6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 10:50:58 -0500
Received: from mail.skyhub.de ([78.46.96.112]:55722 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756271Ab3AOPu4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 10:50:56 -0500
Date: Tue, 15 Jan 2013 16:50:53 +0100
From: Borislav Petkov <bp@alien8.de>
To: Yinghai Lu <yinghai@kernel.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@elte.hu>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jan Kiszka <jan.kiszka@web.de>,
        Jason Wessel <jason.wessel@windriver.com>,
        linux-kernel@vger.kernel.org, Rob Landley <rob@landley.net>,
        Matt Fleming <matt.fleming@intel.com>,
        Gokul Caushik <caushik1@gmail.com>,
        Josh Triplett <josh@joshtriplett.org>,
        Joe Millenbach <jmillenbach@gmail.com>
Subject: Re: [PATCH v7u1 22/31] x86, boot: add fields to support load bzImage
 and ramdisk above 4G
Message-ID: <20130115155053.GA8101@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Yinghai Lu <yinghai@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
	Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
	"Eric W. Biederman" <ebiederm@xmission.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Jan Kiszka <jan.kiszka@web.de>,
	Jason Wessel <jason.wessel@windriver.com>,
	linux-kernel@vger.kernel.org, Rob Landley <rob@landley.net>,
	Matt Fleming <matt.fleming@intel.com>,
	Gokul Caushik <caushik1@gmail.com>,
	Josh Triplett <josh@joshtriplett.org>,
	Joe Millenbach <jmillenbach@gmail.com>
References: <1357260531-11115-23-git-send-email-yinghai@kernel.org>
 <20130113214132.GB17200@liondog.tnic>
 <CAE9FiQVQRAOtw7kiPJO3xszJx9uPFjgK82PjbvTyqzJgujdicw@mail.gmail.com>
 <50F4452D.2060000@zytor.com>
 <CAE9FiQXkgoLKp3ZnOcM9gLDJNGNxUE8WSRXiQy1G_v5Os5_v2A@mail.gmail.com>
 <50F455A3.4070706@zytor.com>
 <CAE9FiQUtbpo0njyPjPED=esKKnSdFs9ry4pFjG1y0LvHxkqV4w@mail.gmail.com>
 <50F46304.3010108@zytor.com>
 <CAE9FiQU_8ngBbXbwrqC1SaR3fScoDNvO_nKOhDYBV_bjOzjwJg@mail.gmail.com>
 <CAE9FiQWxWdeGB-DZp7W2rmukG-KPahF8SQbBcHUWbbUAJA2MhA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAE9FiQWxWdeGB-DZp7W2rmukG-KPahF8SQbBcHUWbbUAJA2MhA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 14, 2013 at 10:17:10PM -0800, Yinghai Lu wrote:
> Please check if I miss anything that must be addressed.

Well, I'm staring at your for-x86-boot branch with top-commit
e6bee79e9f177991a35f1bda9ed704cfbcb8e4a3 and well, you've missed almost
everything.

I've made a gazillion comments to your patches in the last week and
you've taken almost none of it. It's like I've been talking to myself
the whole time, but with audience.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
