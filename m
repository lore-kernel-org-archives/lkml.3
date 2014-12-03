Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933538AbaLCAEE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 19:04:04 -0500
Received: from www.linutronix.de ([62.245.132.108]:50396 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933271AbaLCAEC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 19:04:02 -0500
Date: Wed, 3 Dec 2014 01:03:43 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: =?ISO-8859-15?Q?Peter_H=FCwe?= <PeterHuewe@gmx.de>
cc: tpmdd-devel@lists.sourceforge.net,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        christophe.ricard@gmail.com, josh.triplett@intel.com,
        linux-api@vger.kernel.org, Ashley Lai <ashley@ashleylai.com>,
        linux-kernel@vger.kernel.org, jason.gunthorpe@obsidianresearch.com,
        trousers-tech@lists.sourceforge.net
Subject: Re: [tpmdd-devel] [PATCH v8 0/8] TPM 2.0 support
In-Reply-To: <201412030021.07882.PeterHuewe@gmx.de>
Message-ID: <alpine.DEB.2.11.1412030101400.16275@nanos>
References: <1417559480-13757-1-git-send-email-jarkko.sakkinen@linux.intel.com> <201412030016.20268.PeterHuewe@gmx.de> <201412030021.07882.PeterHuewe@gmx.de>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323329-758534258-1417565024=:16275"
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323329-758534258-1417565024=:16275
Content-Type: TEXT/PLAIN; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT

On Wed, 3 Dec 2014, Peter Hüwe wrote:
> From: Peter Huewe <peterhuewe@gmx.de>
> Date: Wed, 3 Dec 2014 00:18:52 +0100
> Subject: [PATCH] tpm:tpm_i2c_nuvoton: simpyl return statements

simpyl?
 
> if !rc evals to false it is 0
> -> we can return rc in both cases

Why assigning rc and returning it when you can return the result of
tpm_chip_register() right away?
 
Thanks,

	tglx
--8323329-758534258-1417565024=:16275--
