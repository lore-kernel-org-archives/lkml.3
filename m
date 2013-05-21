Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753915Ab3EUOpI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 May 2013 10:45:08 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40798 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753251Ab3EUOpH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 May 2013 10:45:07 -0400
Date: Tue, 21 May 2013 16:45:49 +0200
From: Alexander Gordeev <agordeev@redhat.com>
To: Mike Qiu <qiudayu@linux.vnet.ibm.com>
Cc: linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        benh@kernel.crashing.org, tglx@linutronix.de
Subject: Re: [PATCH 0/3] Enable multiple MSI feature in pSeries
Message-ID: <20130521144548.GB21632@dhcp-26-207.brq.redhat.com>
References: <1358235536-32741-1-git-send-email-qiudayu@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1358235536-32741-1-git-send-email-qiudayu@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 15, 2013 at 03:38:53PM +0800, Mike Qiu wrote:
> The test results is shown by 'cat /proc/interrups':
>           CPU0       CPU1       CPU2       CPU3       
> 16:     240458     261601     226310     200425      XICS Level     IPI
> 17:          0          0          0          0      XICS Level     RAS_EPOW
> 18:         10          0          3          2      XICS Level     hvc_console
> 19:     122182      28481      28527      28864      XICS Level     ibmvscsi
> 20:        506    7388226        108        118      XICS Level     eth0
> 21:          6          5          5          5      XICS Level     host1-0
> 22:        817        814        816        813      XICS Level     host1-1

Hi Mike,

I am curious if pSeries firmware allows changing affinity masks independently
for multiple MSIs? I.e. in your example, would it be possible to assign IRQ21
and IRQ22 to different CPUs?

Thanks!

> LOC:     398077     316725     231882     203049   Local timer interrupts
> SPU:       1659        919        961        903   Spurious interrupts
> CNT:          0          0          0          0   Performance
> monitoring interrupts
> MCE:          0          0          0          0   Machine check exceptions

-- 
Regards,
Alexander Gordeev
agordeev@redhat.com
