Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752299AbaCFXcw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2014 18:32:52 -0500
Received: from mail-ea0-f175.google.com ([209.85.215.175]:64870 "EHLO
	mail-ea0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750829AbaCFXcv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2014 18:32:51 -0500
Message-ID: <5319059E.1010205@gmail.com>
Date: Fri, 07 Mar 2014 00:32:46 +0100
From: poma <pomidorabelisima@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: netdev@vger.kernel.org
CC: Intel Corporation <linux.nics@intel.com>,
        Mailing-List fedora-kernel <kernel@lists.fedoraproject.org>,
        Linux Kernel list <linux-kernel@vger.kernel.org>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Stanislaw Gruszka <sgruszka@redhat.com>,
        Josh Boyer <jwboyer@redhat.com>,
        "Justin M. Forbes" <jforbes@redhat.com>,
        Francois Romieu <romieu@fr.zoreil.com>, Dan Williams <dcbw@redhat.com>
Subject: Re: WARNING: CPU: 0 PID: 0 at net/sched/sch_generic.c:264 dev_watchdog+0x276/0x280()
References: <530332B7.10909@gmail.com> <53043521.4060206@gmail.com>
In-Reply-To: <53043521.4060206@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

...
After a few dozen tests with the vanilla commits, and with the same
amount of rawhide kernels ...
https://bugzilla.redhat.com/attachment.cgi?id=871694

Dan, Francois you are both welcome with comments!
Thanks.

poma

