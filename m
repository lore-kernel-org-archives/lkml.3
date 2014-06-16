Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753482AbaFPEzY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 00:55:24 -0400
Received: from mga02.intel.com ([134.134.136.20]:57555 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753180AbaFPEzX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 00:55:23 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,483,1400050800"; 
   d="scan'208";a="558021870"
From: "Drokin, Oleg" <oleg.drokin@intel.com>
To: Anil Belur <askb23@gmail.com>
CC: "Dilger, Andreas" <andreas.dilger@intel.com>,
        "<gregkh@linuxfoundation.org>" <gregkh@linuxfoundation.org>,
        "<linux-kernel@vger.kernel.org>" <linux-kernel@vger.kernel.org>,
        "<hpdd-discuss@lists.01.org>" <hpdd-discuss@ml01.01.org>
Subject: Re: [PATCH v3 1/7] staging: lustre: lclient: glimpse.c fixing
 coding style issues
Thread-Topic: [PATCH v3 1/7] staging: lustre: lclient: glimpse.c fixing
 coding style issues
Thread-Index: AQHPiRuPTrj43jblBEGJQonCj1KsSZtzoWwA
Date: Mon, 16 Jun 2014 04:55:08 +0000
Message-ID: <B0C4F83C-ACD6-49D0-B841-DBE1CBE3F5FC@intel.com>
References: <1402892916-5298-1-git-send-email-askb23@gmail.com>
In-Reply-To: <1402892916-5298-1-git-send-email-askb23@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.255.12.165]
Content-Type: text/plain; charset="us-ascii"
Content-ID: <22213718334E1F48AF3FF8732162ADE5@intel.com>
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello!

On Jun 16, 2014, at 12:28 AM, Anil Belur wrote:

> From: Anil Belur <askb23@gmail.com>
> 
> Fixed "ERROR: need consistent spacing around '+' (ctx:WxV)"
> 
> Signed-off-by: Anil Belur <askb23@gmail.com>
> ---
> drivers/staging/lustre/lustre/lclient/glimpse.c | 2 +-
> 1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/staging/lustre/lustre/lclient/glimpse.c b/drivers/staging/lustre/lustre/lclient/glimpse.c
> index 7bbca4b..60a6e6e 100644
> --- a/drivers/staging/lustre/lustre/lclient/glimpse.c
> +++ b/drivers/staging/lustre/lustre/lclient/glimpse.c
> @@ -177,7 +177,7 @@ static int cl_io_get(struct inode *inode, struct lu_env **envout,
> 			io->ci_obj = clob;
> 			*envout = env;
> 			*ioout  = io;
> -			result = +1;
> +			result = + 1;

This looks wrong.
Here +1 is apparently meant as +1 (compare to -1) to underscore it's positive nature.
If you wanted to drop the +, that'd be fine, I guess, but in your version it looks outright wrong to me (I tested and it compiles, though).

Bye,
    Oleg