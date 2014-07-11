Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753791AbaGKNRz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 09:17:55 -0400
Received: from mail.windriver.com ([147.11.1.11]:36417 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753672AbaGKNRy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 09:17:54 -0400
Message-ID: <53BFE3C8.700@windriver.com>
Date: Fri, 11 Jul 2014 08:16:56 -0500
From: Jason Wessel <jason.wessel@windriver.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Daniel Thompson <daniel.thompson@linaro.org>
CC: <patches@linaro.org>, <linaro-kernel@lists.linaro.org>,
        <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, John Stultz <john.stultz@linaro.org>,
        Anton Vorontsov <anton.vorontsov@linaro.org>,
        Colin Cross <ccross@android.com>, <kernel-team@android.com>,
        <kgdb-bugreport@lists.sourceforge.net>
Subject: Re: [RESEND PATCH v5 3.16-rc4 0/8] kdb: Allow selective reduction
 in capabilities
References: <1399381429-16194-1-git-send-email-daniel.thompson@linaro.org> <1405078418-14070-1-git-send-email-daniel.thompson@linaro.org>
In-Reply-To: <1405078418-14070-1-git-send-email-daniel.thompson@linaro.org>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/11/2014 06:33 AM, Daniel Thompson wrote:
> This patchset implements restricted modes for the KDB debugger. It is a
> continuation of previous work of Anton Vorontsov. There are no
> outstanding review comments for this patchset.
>
> It provides a means for the root user to choose the set of kdb commands
> that are available on the kdb console. It is implemented similarly to
> the existing code to mask the available magic SysRq commands with modes
> for disable-all (0), enable-all(1) and a bitmask to enable/disable
> groups of functionality.
>
> The implementation of the mask check includes a feature to allow a
> command to change which group it belongs to based on whether or not the
> command has arguments (for example, go without arguments is a very safe
> command whilst go with an argument allows arbitrary changes to the
> program counter).
>
> There are a few patches, some are just cleanups, some are churn-ish
> cleanups, but inevitable. And the rest implements the mode -- after all
> the preparations, everything is pretty straightforward.

I plan to take one more walk through the code and aim to get this merged for the upcoming merge window.  :-)

Cheers,
Jason.

