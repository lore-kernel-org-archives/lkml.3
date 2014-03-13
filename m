Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753220AbaCMDtn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2014 23:49:43 -0400
Received: from terminus.zytor.com ([198.137.202.10]:59863 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752966AbaCMDtm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2014 23:49:42 -0400
Message-ID: <53212A96.8020005@zytor.com>
Date: Wed, 12 Mar 2014 20:48:38 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: stefani@seibold.net, Andy Lutomirski <luto@amacapital.net>
CC: Greg KH <gregkh@linuxfoundation.org>, linux-kernel@vger.kernel.org,
        X86 ML <x86@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Andi Kleen <ak@linux.intel.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        John Stultz <john.stultz@linaro.org>,
        Pavel Emelyanov <xemul@parallels.com>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        andriy.shevchenko@linux.intel.com,
        Martin Runge <Martin.Runge@rohde-schwarz.com>,
        Andreas Brief <Andreas.Brief@rohde-schwarz.com>
Subject: Re: [PATCH 0/3] Improve 32 bit vDSO time
References: <1394664680-17799-1-git-send-email-stefani@seibold.net> <CALCETrViaEdPsZO_xKaoihkNzayB+vhwpAO0YvNbfXZH2tOLUg@mail.gmail.com> <20140313001143.Horde.HpQnD8JBClJFZRY7b8BtnQ1@webmail.your-server.de>
In-Reply-To: <20140313001143.Horde.HpQnD8JBClJFZRY7b8BtnQ1@webmail.your-server.de>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/12/2014 04:11 PM, stefani@seibold.net wrote:
> 
> I will do this when your patch is pulled into tip. For now we have the
> choice, but i preferer our solution removing the compat vdso.
> 

Sorry, that didn't parse from me.

Also, if you state a preference, could you please motivate it?

	-hpa


