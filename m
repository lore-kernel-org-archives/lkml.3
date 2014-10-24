Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756360AbaJXPxw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2014 11:53:52 -0400
Received: from bh-25.webhostbox.net ([208.91.199.152]:45440 "EHLO
	bh-25.webhostbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751653AbaJXPxu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2014 11:53:50 -0400
Date: Fri, 24 Oct 2014 08:53:40 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: James Hogan <james.hogan@imgtec.com>
Cc: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        adi-buildroot-devel@lists.sourceforge.net, linux390@de.ibm.com,
        linux-alpha@vger.kernel.org, linux-am33-list@redhat.com,
        linux-arm-kernel@lists.infradead.org, linux-c6x-dev@linux-c6x.org,
        linux-cris-kernel@axis.com, linux-hexagon@vger.kernel.org,
        linux-ia64@vger.kernel.org, linux@openrisc.net,
        linux-m68k@vger.kernel.org, linux-metag@vger.kernel.org,
        linux-mips@linux-mips.org, linux-parisc@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-s390@vger.kernel.org,
        linux-sh@vger.kernel.org, linux-xtensa@linux-xtensa.org,
        sparclinux@vger.kernel.org,
        user-mode-linux-devel@lists.sourceforge.net,
        user-mode-linux-user@lists.sourceforge.net, x86@kernel.org,
        xen-devel@lists.xenproject.org
Subject: Re: [PATCH v2 08/47] kernel: Move pm_power_off to common code
Message-ID: <20141024155340.GA22426@roeck-us.net>
References: <1413864783-3271-1-git-send-email-linux@roeck-us.net>
 <1413864783-3271-9-git-send-email-linux@roeck-us.net>
 <544A2017.7020804@imgtec.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <544A2017.7020804@imgtec.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Authenticated_sender: guenter@roeck-us.net
X-OutGoing-Spam-Status: No, score=0.0
X-CTCH-PVer: 0000001
X-CTCH-Spam: Unknown
X-CTCH-VOD: Unknown
X-CTCH-Flags: 0
X-CTCH-RefID: str=0001.0A020203.544A760D.02FA,ss=1,re=0.000,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0
X-CTCH-Score: 0.000
X-CTCH-ScoreCust: 0.000
X-CTCH-Rules: C_4847,
X-CTCH-SenderID: linux@roeck-us.net
X-CTCH-SenderID-Flags: 0
X-CTCH-SenderID-TotalMessages: 2
X-CTCH-SenderID-TotalSpam: 0
X-CTCH-SenderID-TotalSuspected: 0
X-CTCH-SenderID-TotalConfirmed: 0
X-CTCH-SenderID-TotalBulk: 0
X-CTCH-SenderID-TotalVirus: 0
X-CTCH-SenderID-TotalRecipients: 0
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - bh-25.webhostbox.net
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - roeck-us.net
X-Get-Message-Sender-Via: bh-25.webhostbox.net: mailgid no entry from get_relayhosts_entry
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 24, 2014 at 10:47:03AM +0100, James Hogan wrote:
> Hi Guenter,
> 
> On 21/10/14 05:12, Guenter Roeck wrote:
> > pm_power_off is defined for all architectures. Move it to common code.
> > 
> > Have all architectures call do_kernel_power_off instead of pm_power_off.
> > Some architectures point pm_power_off to machine_power_off. For those,
> > call do_kernel_power_off from machine_power_off instead.
> > 
> > Acked-by: David Vrabel <david.vrabel@citrix.com>
> > Acked-by: Geert Uytterhoeven <geert@linux-m68k.org>
> > Acked-by: Hirokazu Takata <takata@linux-m32r.org>
> > Acked-by: Jesper Nilsson <jesper.nilsson@axis.com>
> > Acked-by: Max Filippov <jcmvbkbc@gmail.com>
> > Acked-by: Rafael J. Wysocki <rjw@rjwysocki.net>
> > Acked-by: Richard Weinberger <richard@nod.at>
> > Acked-by: Xuetao Guan <gxt@mprc.pku.edu.cn>
> 
> For metag:
> Acked-by: James Hogan <james.hogan@imgtec.com>
> 
Thanks!

Guenter
