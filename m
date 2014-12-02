Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934044AbaLBTwP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 14:52:15 -0500
Received: from sw.attotech.com ([208.69.85.34]:60482 "EHLO
	NOTESERV1.attotech.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932551AbaLBTwM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 14:52:12 -0500
X-Greylist: delayed 905 seconds by postgrey-1.27 at vger.kernel.org; Tue, 02 Dec 2014 14:52:12 EST
Message-ID: <547E14E3.1070303@attotech.com>
Date: Tue, 02 Dec 2014 14:37:07 -0500
From: Bradley Grove <bgrove@attotech.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Bradley Grove <linuxdrivers@attotech.com>,
        "James E.J. Bottomley" <JBottomley@parallels.com>, trivial@kernel.org
CC: Boris Bodemann <bobo.barbarossa@gmail.com>, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 1/1] esas2r: Correct typos of "validate" in a comment
References: <54774D8D.2030204@gmail.com>
In-Reply-To: <54774D8D.2030204@gmail.com>
X-MIMETrack: Itemize by SMTP Server on NOTESERV2/SERV/ATTO(Release 9.0|March 08, 2013) at
 12/02/2014 02:37:05 PM,
	Serialize by Router on NOTESERV1/SERV/ATTO(Release 9.0|March 08, 2013) at
 12/02/2014 02:52:12 PM,
	Serialize complete at 12/02/2014 02:52:12 PM
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Acked-by: Bradley Grove <bgrove@attotech.com>

Thanks,
Brad

On 11/27/2014 11:13 AM, Boris Bodemann wrote:
> From: Boris Bodemann <bobo.barbarossa@gmail.com>
>
> Correct typos of "validate" in a comment
>
> Signed-off-by: Boris Bodemann <bobo.barbarossa@gmail.com>
> ---
> diff -up a/drivers/scsi/esas2r/esas2r_flash.c b/drivers/scsi/esas2r/esas2r_flash.c
> --- a/drivers/scsi/esas2r/esas2r_flash.c        2014-11-21 18:24:10.000000000 +0100
> +++ b/drivers/scsi/esas2r/esas2r_flash.c        2014-11-27 14:49:03.029899303 +0100
> @@ -684,9 +684,9 @@ static u16 calc_fi_checksum(struct esas2
>    *              1)  verify the fi_version is correct
>    *              2)  verify the checksum of the entire image.
>    *              3)  validate the adap_typ, action and length fields.
> - *              4)  valdiate each component header. check the img_type and
> + *              4)  validate each component header. check the img_type and
>    *                  length fields
> - *              5)  valdiate each component image.  validate signatures and
> + *              5)  validate each component image.  validate signatures and
>    *                  local checksums
>    */
>   static bool verify_fi(struct esas2r_adapter *a,
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

