Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754502AbaHLCRN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2014 22:17:13 -0400
Received: from mga14.intel.com ([192.55.52.115]:2302 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752777AbaHLCRL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2014 22:17:11 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,846,1400050800"; 
   d="scan'208";a="575313454"
From: "Drokin, Oleg" <oleg.drokin@intel.com>
To: Srikrishan Malik <srikrishanmalik@gmail.com>
CC: "<greg@kroah.com>" <greg@kroah.com>,
        "Dilger, Andreas" <andreas.dilger@intel.com>,
        "<devel@driverdev.osuosl.org>" <devel@driverdev.osuosl.org>,
        "<linux-kernel@vger.kernel.org>" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 08/13] staging: lustre: fix multi line strings
Thread-Topic: [PATCH v2 08/13] staging: lustre: fix multi line strings
Thread-Index: AQHPtZJbX9ibFvEgw0mPyrtggdGpP5vMsTuA
Date: Tue, 12 Aug 2014 02:17:07 +0000
Message-ID: <FBE0C2BE-D82B-40E6-93B2-929E66130883@intel.com>
References: <1407781659-728-1-git-send-email-srikrishanmalik@gmail.com>
 <1407781659-728-8-git-send-email-srikrishanmalik@gmail.com>
In-Reply-To: <1407781659-728-8-git-send-email-srikrishanmalik@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.254.188.74]
Content-Type: text/plain; charset="us-ascii"
Content-ID: <CFF6005A58F0BF4AA4FA7E40CCCFE1FA@intel.com>
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Aug 11, 2014, at 2:27 PM, Srikrishan Malik wrote:

> Fixes the following checkpatch warning:
> 
> WARNING: quoted string split across lines

> diff --git a/drivers/staging/lustre/lustre/mdc/mdc_request.c b/drivers/staging/lustre/lustre/mdc/mdc_request.c
> index 57d903156917..6c691a4763b5 100644
> --- a/drivers/staging/lustre/lustre/mdc/mdc_request.c
> +++ b/drivers/staging/lustre/lustre/mdc/mdc_request.c
> @@ -2055,8 +2055,8 @@ static int mdc_hsm_copytool_send(int len, void *val)
> 		return -EPROTO;
> 	}
> 
> -	CDEBUG(D_HSM, " Received message mg=%x t=%d m=%d l=%d actions=%d "
> -	       "on %s\n",
> +	CDEBUG(D_HSM,
> +	       " Received message mg=%x t=%d m=%d l=%d actions=%d on %s\n",
> 	       lh->kuc_magic, lh->kuc_transport, lh->kuc_msgtype,
> 	       lh->kuc_msglen, hal->hal_count, hal->hal_fsname);

I imagine we can drop the leading space here as well.

Thanks.

Bye,
    Oleg

