Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754126Ab3IQXSc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Sep 2013 19:18:32 -0400
Received: from nm15-vm7.access.bullet.mail.gq1.yahoo.com ([216.39.63.193]:21716
	"EHLO nm15-vm7.access.bullet.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753271Ab3IQXSa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Sep 2013 19:18:30 -0400
X-Yahoo-Newman-Id: 623616.68152.bm@smtp112.sbc.mail.gq1.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: c4OAeaEVM1kLwfUCmMVYI2iCg.ggs6b7QF.pWRMFV0IPRoG
 qzKbXFvQnNJfHtDKK1Q.T_272oHRvgD0INk26..bny6bvXmwoN9LD6_Sdowz
 g92g72ZJxOKIgoOrizoXrFnZl8a5NW8BzHT4kxi6jXnFLSNx_i9drr2Gfu6V
 xfreJWctObxqG_ap.9rfx6Ik7PQ0ntxNK0ITIhtflFh2vuZKRso6UCPsDDqg
 KIYNVdVIWUVFPY0.23ycqdnoAb5v.SPkaqmsJ5keKkqaNEgw.RbLf7wCu7E5
 eTnO7PWAT_JEuJKYQ4WD_eLStXA5qjdrWb5eAgWdorefGm9U38nXDSNJ.7TP
 TYVtpIpfYnlGoHaqsQN20Vh9IAQ5pyaPqaIUczEEiB6lU4snm6HvskJQ0Ye8
 _TUGi0LKbTWkWxr6UPkDYr6AEY5jskEGaK0oYeLlFL.ekQf.lVrXGh.h8PkK
 AnJIBYGx2e1q.D6_G8HGUYkfQDbgoxYy07fYs1rmHFoE1PYYyFwxW28oZx.Y
 eSMkZQP7SZYMGBIuGtbGDXIFaGnkx5_9H9ZFlK84UhcHJT562FW1pSJPL4Uz
 67qyCltQNvTk-
X-Yahoo-SMTP: xXkkXk6swBBAi.5wfkIWFW3ugxbrqyhyk_b4Z25Sfu.XGQ--
X-Rocket-Received: from [192.168.1.4] (danielfsantos@99.70.244.137 with )
        by smtp112.sbc.mail.gq1.yahoo.com with SMTP; 17 Sep 2013 16:18:29 -0700 PDT
Message-ID: <5238E35F.3060206@att.net>
Date: Tue, 17 Sep 2013 18:18:55 -0500
From: Daniel Santos <danielfsantos@att.net>
Reply-To: Daniel Santos <daniel.santos@pobox.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130730 Thunderbird/17.0.7
MIME-Version: 1.0
To: Daniel Santos <daniel.santos@pobox.com>
CC: linux-kbuild <linux-kbuild@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Michal Marek <mmarek@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        David Howells <dhowells@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Michael Kerrisk <mtk.manpages@gmail.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        George Spelvin <linux@horizon.com>
Subject: Re: [PATCH 2/5] lib: Add .config options for error strings in printks
References: <1379459317-13046-1-git-send-email-daniel.santos@pobox.com> <1379459317-13046-3-git-send-email-daniel.santos@pobox.com>
In-Reply-To: <1379459317-13046-3-git-send-email-daniel.santos@pobox.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/17/2013 06:08 PM, danielfsantos@att.net wrote:
> --- a/lib/Kconfig.debug
> +++ b/lib/Kconfig.debug
> @@ -58,6 +58,7 @@ config DYNAMIC_DEBUG
>   	  implicitly compiles in all pr_debug() and dev_dbg() calls, which
>   	  enlarges the kernel text size by about 2%.
>   
> +
>   	  If a source file is compiled with DEBUG flag set, any
>   	  pr_debug() calls in it are enabled by default, but can be
>   	  disabled at runtime as below.  Note that DEBUG flag is
> @@ -113,6 +114,58 @@ config DYNAMIC_DEBUG
whoops! Please ignore this carriage return! :)

