Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751616AbaDAOUQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 10:20:16 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:20361 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751153AbaDAOUO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 10:20:14 -0400
Date: Tue, 1 Apr 2014 17:19:51 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Guido =?iso-8859-1?Q?Mart=EDnez?= <guido@vanguardiasur.com.ar>
Cc: linux-kernel@vger.kernel.org, Greg KH <gregkh@linuxfoundation.org>,
        driverdev-devel@linuxdriverproject.org,
        Ezequiel =?iso-8859-1?Q?Garc=EDa?= 
	<ezequiel@vanguardiasur.com.ar>,
        Walter Lozano <walter@vanguardiasur.com.ar>,
        Forest Bond <forest@alittletooquiet.net>
Subject: Re: [PATCH 2/3] staging: vt6655: remove dead code
Message-ID: <20140401141951.GU6991@mwanda>
References: <1396356733-5344-1-git-send-email-guido@vanguardiasur.com.ar>
 <1396356733-5344-3-git-send-email-guido@vanguardiasur.com.ar>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1396356733-5344-3-git-send-email-guido@vanguardiasur.com.ar>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 01, 2014 at 09:52:12AM -0300, Guido Martínez wrote:
> @@ -2205,11 +2203,8 @@ bool BBbVT3253Init(PSDevice pDevice)
>  		//}}
>  		bResult &= BBbWriteEmbedded(dwIoBase, 0xb0, 0x58);
>  
> -		for (ii = 0; ii < CB_VT3253B0_AGC; ii++) {
> +		for (ii = 0; ii < CB_VT3253B0_AGC; ii++)
>  			bResult &= BBbWriteEmbedded(dwIoBase, byVT3253B0_AGC[ii][0], byVT3253B0_AGC[ii][1]);
> -		}

This isn't "deleting dead code".  Do it in a separate patch.

regards,
dan carpenter

