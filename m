Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755561AbaJWMeK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2014 08:34:10 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:37216 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755286AbaJWMeG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2014 08:34:06 -0400
Date: Thu, 23 Oct 2014 15:33:51 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Eric Rost <eric.rost@mybabylon.net>
Cc: gregkh@linuxfoundation.org, jason@lakedaemon.net, jake@lwn.net,
        antonysaraev@gmail.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/2] staging: skein: Add Loadable Module Support
Message-ID: <20141023123351.GQ23154@mwanda>
References: <cover.1414030776.git.eric.rost@mybabylon.net>
 <6465068320badb589bcbd2cf37f4700e2cef0406.1414030776.git.eric.rost@mybabylon.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6465068320badb589bcbd2cf37f4700e2cef0406.1414030776.git.eric.rost@mybabylon.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 22, 2014 at 09:24:37PM -0500, Eric Rost wrote:
> +static int __init skein_generic_mod_init(void)
> +{
> +	return crypto_register_shash(&alg256) || crypto_register_shash(&alg512)
> +		|| crypto_register_shash(&alg1024);

Shouldn't it unwind on error?

> +}

regards,
dan carpenter
