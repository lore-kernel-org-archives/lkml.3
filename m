Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933429AbaLBX2o (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 18:28:44 -0500
Received: from mout.gmx.net ([212.227.15.18]:63663 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932722AbaLBX2n convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 18:28:43 -0500
From: Peter =?iso-8859-1?q?H=FCwe?= <PeterHuewe@gmx.de>
To: Aaro Koskinen <aaro.koskinen@iki.fi>
Subject: Re: [tpmdd-devel] [PATCH v8 0/8] TPM 2.0 support
Date: Wed, 3 Dec 2014 00:33:56 +0100
User-Agent: KMail/1.13.7 (Linux/3.18.0-rc6-dirty; KDE/4.12.5; x86_64; ; )
Cc: tpmdd-devel@lists.sourceforge.net,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        christophe.ricard@gmail.com, josh.triplett@intel.com,
        linux-api@vger.kernel.org, Ashley Lai <ashley@ashleylai.com>,
        linux-kernel@vger.kernel.org, jason.gunthorpe@obsidianresearch.com,
        trousers-tech@lists.sourceforge.net
References: <1417559480-13757-1-git-send-email-jarkko.sakkinen@linux.intel.com> <201412030021.07882.PeterHuewe@gmx.de> <20141202232442.GB14524@fuloong-minipc.musicnaut.iki.fi>
In-Reply-To: <20141202232442.GB14524@fuloong-minipc.musicnaut.iki.fi>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Message-Id: <201412030033.56705.PeterHuewe@gmx.de>
X-Provags-ID: V03:K0:SydFNH+o+8laCZHn92rCBPZKne+jqWMpsS173XdvRVBJF3sTiPp
 h4V6WG/PUypjXY4fgI3XxNQhVVOTCo9mD9bRp/Ivd7McUgd6lfNH6CTjZvMt9YHJ93CJtGC
 SyHnwmPbSkViH27uPqu8bfxnyD4qB4XCNJcp/yqPkG+NUfTjL1JmzWfKfohVPHu8cKJSjoQ
 amN4NJ2MiM40ERSsjAr+Q==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Mittwoch, 3. Dezember 2014, 00:24:43 schrieb Aaro Koskinen:
> Hi,
> 
> On Wed, Dec 03, 2014 at 12:21:07AM +0100, Peter Hüwe wrote:
> > --- a/drivers/char/tpm/tpm_i2c_nuvoton.c
> > +++ b/drivers/char/tpm/tpm_i2c_nuvoton.c
> > @@ -605,10 +605,8 @@ static int i2c_nuvoton_probe(struct i2c_client
> > *client,
> > 
> >  		return -ENODEV;
> >  	
> >  	rc = tpm_chip_register(chip);
> > 
> > -	if (rc)
> > -		return rc;
> > 
> > -	return 0;
> > +	return rc;
> 
> Maybe just return tpm_chip_register(chip)?

Even better.

(I should go to bed now ;)
Peter
