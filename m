Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932648AbaD2H2e (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 03:28:34 -0400
Received: from terminus.zytor.com ([198.137.202.10]:57331 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751644AbaD2H2d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 03:28:33 -0400
Message-ID: <535F5490.5020504@zytor.com>
Date: Tue, 29 Apr 2014 00:28:16 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Jiri Slaby <jslaby@suse.cz>, rostedt@goodmis.org
CC: jirislaby@gmail.com, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>, x86@kernel.org,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH 2/2] fentry: x86, cleanup function_hook uses
References: <1398756247-29536-1-git-send-email-jslaby@suse.cz> <1398756247-29536-2-git-send-email-jslaby@suse.cz>
In-Reply-To: <1398756247-29536-2-git-send-email-jslaby@suse.cz>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/29/2014 12:24 AM, Jiri Slaby wrote:
> Let's define fentry_hook depending on CC_USING_FENTRY and use that
> macro all over. This saves some #ifdef's here and there.

Any reason not to use the existing macro name function_hook?

(Valid reasons include "too generic".  However, please motivate in the
commit message.)

	-hpa

