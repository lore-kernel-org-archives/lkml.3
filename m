Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752474AbaCLXMR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2014 19:12:17 -0400
Received: from www84.your-server.de ([213.133.104.84]:56714 "EHLO
	www84.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752090AbaCLXMO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2014 19:12:14 -0400
Date: Thu, 13 Mar 2014 00:11:43 +0100
Message-ID: <20140313001143.Horde.HpQnD8JBClJFZRY7b8BtnQ1@webmail.your-server.de>
From: stefani@seibold.net
To: Andy Lutomirski <luto@amacapital.net>
Cc: Greg KH <gregkh@linuxfoundation.org>, linux-kernel@vger.kernel.org,
        X86 ML <x86@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Andi Kleen <ak@linux.intel.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        John Stultz <john.stultz@linaro.org>,
        Pavel Emelyanov <xemul@parallels.com>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        andriy.shevchenko@linux.intel.com,
        Martin Runge <Martin.Runge@rohde-schwarz.com>,
        Andreas Brief <Andreas.Brief@rohde-schwarz.com>
Subject: Re: [PATCH 0/3] Improve 32 bit vDSO time
References: <1394664680-17799-1-git-send-email-stefani@seibold.net>
 <CALCETrViaEdPsZO_xKaoihkNzayB+vhwpAO0YvNbfXZH2tOLUg@mail.gmail.com>
In-Reply-To: <CALCETrViaEdPsZO_xKaoihkNzayB+vhwpAO0YvNbfXZH2tOLUg@mail.gmail.com>
User-Agent: Internet Messaging Program (IMP) H5 (6.1.6)
Content-Type: text/plain; charset=UTF-8; format=flowed; DelSp=Yes
MIME-Version: 1.0
Content-Disposition: inline
X-Authenticated-Sender: stefani@seibold.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Zitat von Andy Lutomirski <luto@amacapital.net>:

> Since no one seems to object to the latest patch I sent out, wouldn't
> it make more sense to base this on top of my patch?
>

I will do this when your patch is pulled into tip. For now we have the choice,
but i preferer our solution removing the compat vdso.

- Stefani

