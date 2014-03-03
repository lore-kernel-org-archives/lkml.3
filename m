Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754152AbaCCKBx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2014 05:01:53 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:27958 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753693AbaCCKBw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2014 05:01:52 -0500
Date: Mon, 3 Mar 2014 13:01:33 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Oleg Drokin <green@linuxhacker.ru>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
        Oleg Drokin <oleg.drokin@intel.com>,
        "John L. Hammond" <john.hammond@intel.com>
Subject: Re: [PATCH 01/17] staging/lustre/llite: fix open lock matching in
 ll_md_blocking_ast()
Message-ID: <20140303100133.GM26722@mwanda>
References: <1393640206-20286-1-git-send-email-green@linuxhacker.ru>
 <1393640206-20286-2-git-send-email-green@linuxhacker.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1393640206-20286-2-git-send-email-green@linuxhacker.ru>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 28, 2014 at 09:16:30PM -0500, Oleg Drokin wrote:
>  
> -	if (och) { /* There might be a race and somebody have freed this och
> -		      already */
> +	if (och != NULL) {
> +		/* There might be a race and this handle may already
> +		   be closed. */

This is a random unrelated whitespace change and the style was better in
the original (double negatives are not not stupid).

regards,
dan carpenter

