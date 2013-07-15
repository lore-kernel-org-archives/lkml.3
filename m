Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755587Ab3GOVMQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jul 2013 17:12:16 -0400
Received: from terminus.zytor.com ([198.137.202.10]:44901 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754991Ab3GOVMO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jul 2013 17:12:14 -0400
Message-ID: <51E46596.9050702@zytor.com>
Date: Mon, 15 Jul 2013 14:11:50 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Jonas Heinrich <onny@project-insanity.org>,
        Jarkko Sakkinen <jarkko.sakkinen@intel.com>, len.brown@intel.com,
        pavel@ucw.cz, tglx@linutronix.de, mingo@redhat.com, x86@kernel.org,
        linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org
Subject: Re: [Bisected] 3.7-rc1 can't resume (still present in 3.9)
References: <20130218155439.GA902@onny> <201305031515.55595.jarkko.sakkinen@intel.com> <20130708095042.GA20797@onny.Speedport_W_700V> <3442698.l2vNEGx5aV@vostro.rjw.lan>
In-Reply-To: <3442698.l2vNEGx5aV@vostro.rjw.lan>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/08/2013 06:05 AM, Rafael J. Wysocki wrote:
> 
> That's because no one knows how to fix it.  Actually, we don't even know
> what the root cause of it is.  Sorry about that.
> 
> Are you still able to make things work again by reverting the commit you
> bisected to?
> 

Well, we know now.   Hopefully we should have the fix in 3.11-rc2 and
then on its way to stable.

	-hpa


