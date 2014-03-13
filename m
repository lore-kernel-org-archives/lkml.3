Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753353AbaCMILm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2014 04:11:42 -0400
Received: from www84.your-server.de ([213.133.104.84]:55188 "EHLO
	www84.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753109AbaCMILi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2014 04:11:38 -0400
Message-ID: <1394698270.1008.19.camel@wall-e.seibold.net>
Subject: Re: [PATCH 0/3] Improve 32 bit vDSO time
From: Stefani Seibold <stefani@seibold.net>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Andy Lutomirski <luto@amacapital.net>,
        Greg KH <gregkh@linuxfoundation.org>, linux-kernel@vger.kernel.org,
        X86 ML <x86@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Andi Kleen <ak@linux.intel.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        John Stultz <john.stultz@linaro.org>,
        Pavel Emelyanov <xemul@parallels.com>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        andriy.shevchenko@linux.intel.com,
        Martin Runge <Martin.Runge@rohde-schwarz.com>,
        Andreas Brief <Andreas.Brief@rohde-schwarz.com>
Date: Thu, 13 Mar 2014 09:11:10 +0100
In-Reply-To: <53212A96.8020005@zytor.com>
References: <1394664680-17799-1-git-send-email-stefani@seibold.net>
	 <CALCETrViaEdPsZO_xKaoihkNzayB+vhwpAO0YvNbfXZH2tOLUg@mail.gmail.com>
	 <20140313001143.Horde.HpQnD8JBClJFZRY7b8BtnQ1@webmail.your-server.de>
	 <53212A96.8020005@zytor.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: stefani@seibold.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Mittwoch, den 12.03.2014, 20:48 -0700 schrieb H. Peter Anvin:
> On 03/12/2014 04:11 PM, stefani@seibold.net wrote:
> > 
> > I will do this when your patch is pulled into tip. For now we have the
> > choice, but i preferer our solution removing the compat vdso.
> > 
> 
> Sorry, that didn't parse from me.

I thought it is a good idea to wait until the "remove compat vdso
support" is settled and pulled into tip.

If there is no objections against this patch i am happy to do the
job ;-)

BTW: Thanks to Andy for doing this job to git rid off this ugly compat
vDSO layer.

> Also, if you state a preference, could you please motivate it?

For the next three days i am very busy with a important project, so i
will rebase the vdso 32 bit time patch on Monday or Tuesday. 

- Stefani

