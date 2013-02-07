Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759312Ab3BGSSZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 13:18:25 -0500
Received: from mx1.redhat.com ([209.132.183.28]:40201 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758789Ab3BGSSX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 13:18:23 -0500
Date: Thu, 7 Feb 2013 19:17:06 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Andrey Vagin <avagin@openvz.org>
Cc: linux-kernel@vger.kernel.org, criu@openvz.org,
        linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        David Howells <dhowells@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Michael Kerrisk <mtk.manpages@gmail.com>,
        Pavel Emelyanov <xemul@parallels.com>,
        Cyrill Gorcunov <gorcunov@openvz.org>
Subject: Re: [PATCH 2/3] signalfd: add ability to choose a private or
	shared queue
Message-ID: <20130207181706.GA8780@redhat.com>
References: <1358849741-9611-1-git-send-email-avagin@openvz.org> <1358849741-9611-3-git-send-email-avagin@openvz.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1358849741-9611-3-git-send-email-avagin@openvz.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

AOn 01/22, Andrey Vagin wrote:
>
> This patch is added two flags SFD_SHARED_QUEUE and SFD_PER_THREAD_QUEUE
> SFD_SHARED_QUEUE

I can't believe I am going to blame the naming ;) but these 2 do not look
"symmetrical"....

SFD_PRIVATE_QUEUE looks a little bit better to me. At least it is simpler
to type. But I am fine either way.

Oleg.

