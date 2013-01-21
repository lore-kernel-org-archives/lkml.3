Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752006Ab3AUHUk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 02:20:40 -0500
Received: from mail-qc0-f174.google.com ([209.85.216.174]:51185 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750757Ab3AUHUi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 02:20:38 -0500
MIME-Version: 1.0
In-Reply-To: <20130118154504.GA28072@redhat.com>
References: <50E3FDFA.4070203@suse.cz>
	<20130102114311.66215bf5@pyramind.ukuu.org.uk>
	<CAMSQXEHmDb5rUQnT1JNcMCzdaN+gAr+1hR=PyPiDMu7vK5ykxA@mail.gmail.com>
	<50E4854E.8060801@suse.cz>
	<CAMSQXEGU2WmhmMqP7XMK2x39GN9iDDWpg-Wa7_cAauHWx5OWbQ@mail.gmail.com>
	<50F66120.50704@linux.vnet.ibm.com>
	<CAMSQXEE=Qp8kVcEp8nBhNDmOaDMUQUUou+5Z2f8-1znykqy6mQ@mail.gmail.com>
	<50F683D9.1080908@linux.vnet.ibm.com>
	<CAMSQXEHjP5mzs9u5DUmuYgoEceM2OO=E8844-XQ7LPCSECoGRw@mail.gmail.com>
	<50F7D8C2.1030506@linux.vnet.ibm.com>
	<20130118154504.GA28072@redhat.com>
Date: Mon, 21 Jan 2013 08:20:37 +0100
Message-ID: <CAMSQXEE0kLw_3pKPTOcxWd8XF4-jU7NxE8S0Hpdb5YperNWFxA@mail.gmail.com>
Subject: Re: [PATCH] tty: Only wakeup the line discipline idle queue when
 queue is active
From: Ivo Sieben <meltedpianoman@gmail.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Preeti U Murthy <preeti@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
        linux-kernel@vger.kernel.org, Andi Kleen <andi@firstfloor.org>,
        Jiri Slaby <jslaby@suse.cz>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        linux-serial@vger.kernel.org, Alan Cox <alan@linux.intel.com>,
        Greg KH <gregkh@linuxfoundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

2013/1/18 Oleg Nesterov <oleg@redhat.com>:
>
> I can't understand why do you dislike Ivo's simple patch. There are
> a lot of "if (waitqueue_active) wake_up" examples. Even if we add the
> new helpers (personally I don't think this makes sense) , we can do
> this later. Why should we delay this fix?
>

FYI: Greg has added my patch to his tty-next branch, so my fix has
been approved.
Thank you all for reviewing.

Regards,
Ivo Sieben
