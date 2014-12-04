Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752944AbaLDE6v (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 23:58:51 -0500
Received: from mail-qa0-f45.google.com ([209.85.216.45]:52065 "EHLO
	mail-qa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752525AbaLDE6u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 23:58:50 -0500
MIME-Version: 1.0
In-Reply-To: <CALCETrULjLf=WHn9TfRyFH+hac7FYKUWmfDm4_aZ3mP4jEpU3w@mail.gmail.com>
References: <CALCETrULjLf=WHn9TfRyFH+hac7FYKUWmfDm4_aZ3mP4jEpU3w@mail.gmail.com>
Date: Wed, 3 Dec 2014 20:58:46 -0800
X-Google-Sender-Auth: MenjaFduwtnNX2OAB6aDCGL2Hc0
Message-ID: <CA+55aFxKr+b3t-gcSg3zsLt5Rp_cR-XLwfXstAVur=gYD8UMVA@mail.gmail.com>
Subject: Re: 3.18 nohz + audit regression (Re: [PATCH] context_tracking:
 Restore previous state in schedule_user)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Dave Jones <davej@redhat.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Richard Guy Briggs <rgb@redhat.com>, Eric Paris <eparis@redhat.com>,
        Oleg Nesterov <oleg@redhat.com>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 3, 2014 at 5:29 PM, Andy Lutomirski <luto@amacapital.net> wrote:
>
> So, to summarize the choices for 3.18:
>
> 4. This patch.

I've applied it. The alternatives look worse, and the patch doesn't
look bad. In many ways it looks better than the old user_exit/enter
pair, although obviously the "schedule_user()" name is kind of odd
now. Whatever.

               Linus
