Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932659AbaLAWXr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 17:23:47 -0500
Received: from mail-qc0-f181.google.com ([209.85.216.181]:35802 "EHLO
	mail-qc0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932160AbaLAWXp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 17:23:45 -0500
MIME-Version: 1.0
In-Reply-To: <20141201220929.GA7305@redhat.com>
References: <20141201213357.GA5834@redhat.com>
	<20141201213417.GA5842@redhat.com>
	<CA+55aFz6a99n_bGGi0CrOeWA3KRVdAJtPiF_3iP1aVx_wE+mMA@mail.gmail.com>
	<20141201220929.GA7305@redhat.com>
Date: Mon, 1 Dec 2014 14:23:45 -0800
X-Google-Sender-Auth: 9Try_1wtPiFIBLaM6_d9jqJ-8Go
Message-ID: <CA+55aFx=B59WPLxQVuETk7rD-xxVPggopv95pt+AdMpuEVzxEQ@mail.gmail.com>
Subject: Re: [PATCH 1/1] x86, ticketlock: spin_unlock_wait() can livelock
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Ingo Molnar <mingo@redhat.com>, Jeremy Fitzhardinge <jeremy@goop.org>,
        "Paul E.McKenney" <paulmck@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>, Waiman Long <Waiman.Long@hp.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 1, 2014 at 2:09 PM, Oleg Nesterov <oleg@redhat.com> wrote:
>
> Please look at https://bugzilla.redhat.com/show_bug.cgi?id=1128995

Heh. That's a RH-only bugzilla, I'm not authorized to see it.

              Linus
