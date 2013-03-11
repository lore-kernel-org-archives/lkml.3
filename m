Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754153Ab3CKMis (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 08:38:48 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:25764 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753902Ab3CKMir (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 08:38:47 -0400
Date: Mon, 11 Mar 2013 08:38:36 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Martin Peres <martin.peres@free.fr>
Cc: airlied@linux.ie, bskeggs@redhat.com, marcin.slusarz@gmail.com,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
Subject: Re: nouveau shuts the machine down with v3.9-rc1 (temperature (72 C)
 hit the 'shutdown' threshold).
Message-ID: <20130311123835.GA23154@phenom.dumpdata.com>
References: <20130304184022.GA8222@phenom.dumpdata.com>
 <5134F44C.7040700@free.fr>
 <20130304214110.GA17402@phenom.dumpdata.com>
 <5135D375.9060006@free.fr>
 <20130305154404.GA15271@phenom.dumpdata.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130305154404.GA15271@phenom.dumpdata.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> With that I am still getting the issues (even with an insance delay of 100 seconds).
> Here is the serial log with various runs.

Any thoughts?
> [   13.523878] initcall init_sg+0x0/0x1000 [sg] returned 0 after 5355 usecs
> ^G^G[   13.621376] nouveau  [  PTHERM][0000:00:0d.0] programmed thresholds [ 90(2), 95(3), 145(2), 135(5) ]
> [   13.630487] nouveau 39079] nouveau  [  PTHERM][0000:00:0d.0] Thermal management: automatic
> [   13.646028] nouveau  [  PTHERM][0000:00:0d.0] temperature (218 C) hit the 'downclock' threshold
> [   13.654702] nouveau  [  PTHERM][0000:00:0d.0] temperature (218 C) hit the 'critical' threshold
> [   13.663296] nouveau  [  PTHERM][0000:00:0d.0] temperature (218 C) hit the 'shutdown' threshold
> [   13.671992] [TTM] Zone  kernel: Available graphics memory: 1963774 kiB

Perhaps I've some insanely stupid BIOS?
