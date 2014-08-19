Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751885AbaHSVhu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2014 17:37:50 -0400
Received: from filtteri6.pp.htv.fi ([213.243.153.189]:49037 "EHLO
	filtteri6.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751186AbaHSVht (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2014 17:37:49 -0400
X-Greylist: delayed 500 seconds by postgrey-1.27 at vger.kernel.org; Tue, 19 Aug 2014 17:37:49 EDT
Date: Wed, 20 Aug 2014 00:29:21 +0300
From: Aaro Koskinen <aaro.koskinen@iki.fi>
To: Julian Calaby <julian.calaby@gmail.com>
Cc: Meelis Roos <mroos@linux.ee>, David Miller <davem@davemloft.net>,
        sparclinux <sparclinux@vger.kernel.org>,
        Linux Kernel list <linux-kernel@vger.kernel.org>, hughd@google.com,
        cat.schulze@alice-dsl.net
Subject: Re: sparc64 WARNING: at mm/mmap.c:2757 exit_mmap+0x13c/0x160()
Message-ID: <20140819212921.GE4885@drone.musicnaut.iki.fi>
References: <alpine.SOC.1.00.1407310101550.2065@math.ut.ee>
 <20140730.150722.861254999466992321.davem@davemloft.net>
 <alpine.SOC.1.00.1408131327250.18696@math.ut.ee>
 <20140813.124611.767426770013677.davem@davemloft.net>
 <alpine.SOC.1.00.1408151534480.27263@math.ut.ee>
 <alpine.SOC.1.00.1408181528270.2922@math.ut.ee>
 <20140818173552.GA2126@drone.musicnaut.iki.fi>
 <CAGRGNgUq0-1rDtRJfFQ1ARvPXk6aT+f99-EGCN1vBpd35q2qyg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGRGNgUq0-1rDtRJfFQ1ARvPXk6aT+f99-EGCN1vBpd35q2qyg@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, Aug 19, 2014 at 09:45:03AM +1000, Julian Calaby wrote:
> Stupid question: aren't the Ultra 5 and Ultra 10 essentially
> the same hardware?

Basically yes, but often configurations are different (CPU speed,
memory capacity, peripherals, PROM versions).

A.
