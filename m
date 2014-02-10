Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753084AbaBJS7u (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 13:59:50 -0500
Received: from mail-ea0-f181.google.com ([209.85.215.181]:50813 "EHLO
	mail-ea0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752979AbaBJS7p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 13:59:45 -0500
Message-ID: <52F9219B.5020003@gmail.com>
Date: Mon, 10 Feb 2014 19:59:39 +0100
From: poma <pomidorabelisima@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: Linux Kernel list <linux-kernel@vger.kernel.org>, linux-pm@vger.kernel.org,
        Olaf Hering <olaf@aepfle.de>, Dave Jones <davej@redhat.com>,
        "Justin M. Forbes" <jforbes@redhat.com>,
        Josh Boyer <jwboyer@redhat.com>,
        Stanislaw Gruszka <sgruszka@redhat.com>,
        Mailing-List fedora-kernel <kernel@lists.fedoraproject.org>
Subject: Re: WARNING: CPU: 1 PID: 0 at kernel/time/tick-broadcast.c:668 tick_broadcast_oneshot_control+0x17d/0x190()
References: <52F84A9B.5020008@gmail.com> <alpine.DEB.2.02.1402101056260.21991@ionos.tec.linutronix.de>
In-Reply-To: <alpine.DEB.2.02.1402101056260.21991@ionos.tec.linutronix.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10.02.2014 11:06, Thomas Gleixner wrote:
> On Mon, 10 Feb 2014, poma wrote:
> 
>> [   83.558551]  [<ffffffff81025b17>] amd_e400_idle+0x87/0x130
> 
> So this seems to happen only on AMD machines which use that e400 idle
> mode. I have no idea at the moment whats wrong there. I'll find one of
> those machines and try to reproduce.
> 
> Thanks,
> 
> 	tglx

Thanks for your response! :)
https://bugzilla.redhat.com/show_bug.cgi?id=1031296#c24


poma

