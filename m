Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752277Ab3CAMBW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Mar 2013 07:01:22 -0500
Received: from mail-ob0-f169.google.com ([209.85.214.169]:45280 "EHLO
	mail-ob0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752224Ab3CAMBU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Mar 2013 07:01:20 -0500
MIME-Version: 1.0
In-Reply-To: <1362101815-19968-1-git-send-email-yong.zhang0@gmail.com>
References: <1362101815-19968-1-git-send-email-yong.zhang0@gmail.com>
Date: Fri, 1 Mar 2013 13:01:19 +0100
X-Google-Sender-Auth: EFQ1gn401QgDtDaKDQOJg-b9hc0
Message-ID: <CAONaPpGUwHenOq9p_ktK10HqPCwZ_m9=Nj8qYWpKVxPhqQ8zjw@mail.gmail.com>
Subject: Re: [PATCH] futex: fix unbalanced spin_lock/spin_unlock() in exit_pi_state_list()
From: John Kacur <jkacur@redhat.com>
To: Yong Zhang <yong.zhang0@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-rt-users@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 1, 2013 at 2:36 AM, Yong Zhang <yong.zhang0@gmail.com> wrote:
> From: Yong Zhang <yong.zhang@windriver.com>
>
> Otherwise, below warning is shown somtimes when running some test:

It would be nice to know which test!
----->o SNIP
