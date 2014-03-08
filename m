Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752107AbaCHXaT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Mar 2014 18:30:19 -0500
Received: from mail-ea0-f181.google.com ([209.85.215.181]:34080 "EHLO
	mail-ea0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751669AbaCHXaS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Mar 2014 18:30:18 -0500
Message-ID: <531BA806.4080509@gmail.com>
Date: Sun, 09 Mar 2014 00:30:14 +0100
From: poma <pomidorabelisima@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Francois Romieu <romieu@fr.zoreil.com>
CC: netdev@vger.kernel.org,
        Mailing-List fedora-kernel <kernel@lists.fedoraproject.org>,
        Linux Kernel list <linux-kernel@vger.kernel.org>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Stanislaw Gruszka <sgruszka@redhat.com>,
        Josh Boyer <jwboyer@redhat.com>,
        "Justin M. Forbes" <jforbes@redhat.com>,
        Dan Williams <dcbw@redhat.com>, Thomas Haller <thaller@redhat.com>
Subject: Re: WARNING: CPU: 0 PID: 0 at net/sched/sch_generic.c:264 dev_watchdog+0x276/0x280()
References: <530332B7.10909@gmail.com> <53043521.4060206@gmail.com> <5319059E.1010205@gmail.com> <5319F40F.4040304@gmail.com> <531A737E.4010200@gmail.com> <20140308123528.GA2052@electric-eye.fr.zoreil.com>
In-Reply-To: <20140308123528.GA2052@electric-eye.fr.zoreil.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08.03.2014 13:35, Francois Romieu wrote:
...
> It applies fine against b01d4e68933ec23e43b1046fa35d593cefcf37d1 but
> a bug hides behind the 'start' variable. You may replace it with the
> patch below. The "netif_info(..., "frags ..." debug statement is noisy
> when enabled. Don't use it.
...

You're right!
Thanks.

These are the results with your patch:

- RTL8110s RTL-8169 S3 TEST & r8169-RTL8110s-xmit-v2.patch
https://bugzilla.redhat.com/attachment.cgi?id=872287

- r8169 RTL8110s pacchetto
https://bugzilla.redhat.com/attachment.cgi?id=872299
https://bugzilla.redhat.com/attachment.cgi?id=872299&action=diff


poma


