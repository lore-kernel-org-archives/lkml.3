Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752476AbaA2P4J (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jan 2014 10:56:09 -0500
Received: from b.ns.miles-group.at ([95.130.255.144]:1660 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751635AbaA2P4H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jan 2014 10:56:07 -0500
Message-ID: <52E92494.1090407@nod.at>
Date: Wed, 29 Jan 2014 16:56:04 +0100
From: Richard Weinberger <richard@nod.at>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [BUG] reproducable ubifs reboot assert and corruption
References: <20140122051510.GB17284@gmail.com> <CAFLxGvwmzftdQKSjjjwpFLS8g3EJqMrQ2gU2scBsh2MvG7Wyyw@mail.gmail.com> <20140127163939.GA27809@gmail.com> <20140129053238.GA6035@gmail.com> <52E8AE25.8080502@nod.at> <20140129154622.GB7278@gmail.com>
In-Reply-To: <20140129154622.GB7278@gmail.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Am 29.01.2014 16:46, schrieb Andrew Ruder:
> On Wed, Jan 29, 2014 at 08:30:45AM +0100, Richard Weinberger wrote:
>> BTW: Can you please share your .config?
> 
> No problem.  FYI, this is for a board that is still in development so
> not all my changes have been submitted for inclusion yet.  I would be
> happy to share the changes now if necessary but I've attached the --stat
> to show that as far as mtd/ubifs goes, i'm basically running a stock
> v3.12:

Does the issue also happen if you disable preemption?
i.e. CONFIG_PREEMPT_NONE=y

Maybe it is really a race...

Thanks,
//richard
