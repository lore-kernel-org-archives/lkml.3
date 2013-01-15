Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757317Ab3AOSFT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 13:05:19 -0500
Received: from mx1.redhat.com ([209.132.183.28]:19428 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755686Ab3AOSFR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 13:05:17 -0500
Date: Tue, 15 Jan 2013 19:03:30 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Ivo Sieben <meltedpianoman@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
        linux-kernel@vger.kernel.org, Andi Kleen <andi@firstfloor.org>,
        Preeti U Murthy <preeti@linux.vnet.ibm.com>,
        Jiri Slaby <jslaby@suse.cz>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        linux-serial@vger.kernel.org, Alan Cox <alan@linux.intel.com>,
        Greg KH <gregkh@linuxfoundation.org>
Subject: Re: [PATCH] tty: Only wakeup the line discipline idle queue when
	queue is active
Message-ID: <20130115180330.GA9321@redhat.com>
References: <1355842130-15482-1-git-send-email-meltedpianoman@gmail.com> <50E3FDFA.4070203@suse.cz> <20130102114311.66215bf5@pyramind.ukuu.org.uk> <CAMSQXEHmDb5rUQnT1JNcMCzdaN+gAr+1hR=PyPiDMu7vK5ykxA@mail.gmail.com> <50E4854E.8060801@suse.cz> <CAMSQXEGU2WmhmMqP7XMK2x39GN9iDDWpg-Wa7_cAauHWx5OWbQ@mail.gmail.com> <20130103183611.GA28225@redhat.com> <CAMSQXEGL-ZkHUMSWi_gP2YVSZhfPH7wdxHO8=QyvuNRvGBZ6=Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMSQXEGL-ZkHUMSWi_gP2YVSZhfPH7wdxHO8=QyvuNRvGBZ6=Q@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/15, Ivo Sieben wrote:
>
> It solves an issue for me, and I really would like this patch to be approved.

Agreed.

And even if we want a helper to hide the waitqueue_active(), we can add it
later and convert more users, not just put_ldisc().

Oleg.

