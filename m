Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932290AbaEJPEz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 May 2014 11:04:55 -0400
Received: from mx2.parallels.com ([199.115.105.18]:56166 "EHLO
	mx2.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932092AbaEJPEw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 May 2014 11:04:52 -0400
From: James Bottomley <jbottomley@parallels.com>
To: "fabf@skynet.be" <fabf@skynet.be>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/1 RESEND] drivers/scsi/sd.c: remove positive test on
 unsigned value
Thread-Topic: [PATCH 1/1 RESEND] drivers/scsi/sd.c: remove positive test on
 unsigned value
Thread-Index: AQHPbD21si5bP1ei/UmkEXeMqeg60Zs6Xz4A
Date: Sat, 10 May 2014 15:04:50 +0000
Message-ID: <1399734290.2528.0.camel@dabdike.int.hansenpartnership.com>
References: <20140510124958.b231a1d64d12ecdf97aff393@skynet.be>
In-Reply-To: <20140510124958.b231a1d64d12ecdf97aff393@skynet.be>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [50.46.150.111]
Content-Type: text/plain; charset=US-ASCII
Content-ID: <CD678F8CDC538C469518C1984E45ABDB@sw.swsoft.com>
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2014-05-10 at 12:49 +0200, Fabian Frederick wrote:
> val is unsigned.

Please send to linux-scsi@vger.kernel.org ... this is one of Martin's I
think.

James

> Cc: "James E.J. Bottomley" <JBottomley@parallels.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Signed-off-by: Fabian Frederick <fabf@skynet.be>
> ---
>  drivers/scsi/sd.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
> index efcbcd1..b54d4f8 100644
> --- a/drivers/scsi/sd.c
> +++ b/drivers/scsi/sd.c
> @@ -296,7 +296,7 @@ protection_type_store(struct device *dev, struct device_attribute *attr,
>  	if (err)
>  		return err;
>  
> -	if (val >= 0 && val <= SD_DIF_TYPE3_PROTECTION)
> +	if (val <= SD_DIF_TYPE3_PROTECTION)
>  		sdkp->protection_type = val;
>  
>  	return count;


