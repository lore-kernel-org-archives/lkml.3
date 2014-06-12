Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752545AbaFLTtv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 15:49:51 -0400
Received: from terminus.zytor.com ([198.137.202.10]:36883 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751707AbaFLTtt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 15:49:49 -0400
Message-ID: <539A0422.9010000@zytor.com>
Date: Thu, 12 Jun 2014 12:48:50 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Kees Cook <keescook@chromium.org>, linux-kernel@vger.kernel.org
CC: Randy Dunlap <rdunlap@infradead.org>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, x86@kernel.org,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>,
        Wei Yongjun <yongjun_wei@trendmicro.com.cn>, linux-doc@vger.kernel.org,
        linux-pm@vger.kernel.org
Subject: Re: [PATCH 0/2] make kASLR vs hibernation boot-time selectable
References: <1402602419-27934-1-git-send-email-keescook@chromium.org>
In-Reply-To: <1402602419-27934-1-git-send-email-keescook@chromium.org>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/12/2014 12:46 PM, Kees Cook wrote:
> Distros want to be able to offer CONFIG_RANDOMIZE_BASE as well as
> CONFIG_HIBERNATION in a single kernel. Instead of making kASLR depend on
> !HIBERNATION at compile time, allow kaslr to be selectable at boot time
> (via "kaslr" kernel command line), which will disable hibernation in the
> kernel. In this way the end user can choose which feature they want more
> with hibernation continuing to stay enabled by default (no surprises).

Any way we can make them work together instead?

	-hpa


