Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754407AbaFNCdG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2014 22:33:06 -0400
Received: from terminus.zytor.com ([198.137.202.10]:55130 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754106AbaFNCdF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2014 22:33:05 -0400
Message-ID: <539BB414.9030107@zytor.com>
Date: Fri, 13 Jun 2014 19:31:48 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>, Kees Cook <keescook@chromium.org>
CC: Pavel Machek <pavel@ucw.cz>, LKML <linux-kernel@vger.kernel.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "x86@kernel.org" <x86@kernel.org>, Len Brown <len.brown@intel.com>,
        Wei Yongjun <yongjun_wei@trendmicro.com.cn>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        linux-pm@vger.kernel.org
Subject: Re: [PATCH 0/2] make kASLR vs hibernation boot-time selectable
References: <1402602419-27934-1-git-send-email-keescook@chromium.org> <1737131.VlQuirUC3S@vostro.rjw.lan> <CAGXu5j+BTYup-9cbwSJsKNW4R1e2QY4wVubfpC3s2LVkE4Amow@mail.gmail.com> <1517175.iyVMqh7r2z@vostro.rjw.lan>
In-Reply-To: <1517175.iyVMqh7r2z@vostro.rjw.lan>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/13/2014 05:14 PM, Rafael J. Wysocki wrote:
> 
> How can I obtain a kernel address of the beginning of a given page
> (as represented by struct page) on x86_64 today?
> 

page_to_virt()

	-hpa


