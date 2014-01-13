Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752096AbaAMPs4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 10:48:56 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:48065 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752059AbaAMPsu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 10:48:50 -0500
Date: Mon, 13 Jan 2014 18:48:29 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Julia Lawall <Julia.Lawall@lip6.fr>
Cc: Omar Ramirez Luna <omar.ramirez@copitl.com>, devel@driverdev.osuosl.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/4] staging: tidspbridge: delete useless variable
Message-ID: <20140113154829.GF7444@mwanda>
References: <1389629847-5330-1-git-send-email-Julia.Lawall@lip6.fr>
 <1389629847-5330-5-git-send-email-Julia.Lawall@lip6.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1389629847-5330-5-git-send-email-Julia.Lawall@lip6.fr>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 13, 2014 at 05:17:27PM +0100, Julia Lawall wrote:
> From: Julia Lawall <Julia.Lawall@lip6.fr>
> 
> The variable status is initialized to either 0 or an error code.  Return
> status to propagate the error value.
> 

Could you update the subject to say that the patch was a bugfix.

regards,
dan carpenter

