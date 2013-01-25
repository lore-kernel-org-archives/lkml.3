Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752795Ab3AYOfO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 09:35:14 -0500
Received: from moutng.kundenserver.de ([212.227.126.186]:64583 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750779Ab3AYOfM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 09:35:12 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Peter Ujfalusi <peter.ujfalusi@ti.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Samuel Ortiz <sameo@linux.intel.com>,
        Kevin Hilman <khilman@deeprootsystems.com>,
        Amit Kucheria <amit.kucheria@linaro.org>,
        "Kristo, Tero" <t-kristo@ti.com>
Subject: Re: [PATCH 09/19] mfd/twl4030: don't warn about uninitialized return code
Date: Fri, 25 Jan 2013 14:34:59 +0000
Message-ID: <1459407.9ptS1zguY5@wuerfel>
User-Agent: KMail/4.10 rc3 (Linux/3.8.0-1-generic; KDE/4.9.98; x86_64; ; )
In-Reply-To: <510295BF.80709@ti.com>
References: <1359123276-15833-1-git-send-email-arnd@arndb.de> <1359123276-15833-10-git-send-email-arnd@arndb.de> <510295BF.80709@ti.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:dHcWpI8lVuY9GFJJY57Kp3Fe1BzceRFJZVr3/cmnRBP
 TcvsjO4tfdRyk0B3E24HVlTx6zEE7Wc4Ug8fqk5KQD4A2LZsuH
 mmZtnGgrMs0BoxcLrL0jrqi3aMgzyFPcMFYfH9UuAZQ9lxi58r
 Fu3ey1PUmIfMWSttptq9LBPGy71GtFS4GbYPrNbiR//TtPMIAV
 ob7qr78JOKCBycdlXkRjIARAcQaiCCXpd9sFtq1NPOyR/WM6cX
 PDOsS2li9/8jLZkdITyPRgyqQ56o6mi1HcJ+RAVivzhej/SrI4
 +NdGtuHNAWBHpI4r1mF9gNYybC1eLROPIwM7EQjZF0k4egVFLV
 fLmdvwGlUR6LQjmyn6SQ=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 25 January 2013 15:25:03 Peter Ujfalusi wrote:
> On 01/25/2013 03:14 PM, Arnd Bergmann wrote:
> > If the twl4030_write_script function gets called with
> > a zero length argument, its return value does not
> > get set. We know that all scripts have a nonzero
> > length, but returning an error in case they ever
> > do is probably appropriate.
> > 
> > Without this patch, building omap2plus_defconfig results in:
> > 
> > drivers/mfd/twl4030-power.c: In function 'load_twl4030_script':
> > drivers/mfd/twl4030-power.c:414:5: error: 'err' may be used uninitialized in this function
> 
> I've fixed up Kevin's email since he is no longer with TI and added Tero to
> the CC list since this is *something*-power on OMAP platforms 
> 
> Reviewed-by: Peter Ujfalusi <peter.ujfalusi@ti.com>

Thanks!

I also got the mailing list address wrong on all mails, so I'll
retransmit the whole series in a bit, just waiting for other
quick comments to come in.

	Arnd
