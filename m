Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933286AbaLBXYy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 18:24:54 -0500
Received: from filtteri5.pp.htv.fi ([213.243.153.188]:53623 "EHLO
	filtteri5.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932722AbaLBXYw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 18:24:52 -0500
Date: Wed, 3 Dec 2014 01:24:43 +0200
From: Aaro Koskinen <aaro.koskinen@iki.fi>
To: Peter =?iso-8859-1?Q?H=FCwe?= <PeterHuewe@gmx.de>
Cc: tpmdd-devel@lists.sourceforge.net,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        christophe.ricard@gmail.com, josh.triplett@intel.com,
        linux-api@vger.kernel.org, Ashley Lai <ashley@ashleylai.com>,
        linux-kernel@vger.kernel.org, jason.gunthorpe@obsidianresearch.com,
        trousers-tech@lists.sourceforge.net
Subject: Re: [tpmdd-devel] [PATCH v8 0/8] TPM 2.0 support
Message-ID: <20141202232442.GB14524@fuloong-minipc.musicnaut.iki.fi>
References: <1417559480-13757-1-git-send-email-jarkko.sakkinen@linux.intel.com>
 <201412030016.20268.PeterHuewe@gmx.de>
 <201412030021.07882.PeterHuewe@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <201412030021.07882.PeterHuewe@gmx.de>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wed, Dec 03, 2014 at 12:21:07AM +0100, Peter Hüwe wrote:
> --- a/drivers/char/tpm/tpm_i2c_nuvoton.c
> +++ b/drivers/char/tpm/tpm_i2c_nuvoton.c
> @@ -605,10 +605,8 @@ static int i2c_nuvoton_probe(struct i2c_client *client,
>  		return -ENODEV;
>  
>  	rc = tpm_chip_register(chip);
> -	if (rc)
> -		return rc;
>  
> -	return 0;
> +	return rc;

Maybe just return tpm_chip_register(chip)?

A.
