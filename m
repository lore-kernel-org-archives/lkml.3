Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753747AbaESJI7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 05:08:59 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:17448 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753686AbaESJI4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 05:08:56 -0400
Date: Mon, 19 May 2014 12:08:39 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Anton Saraev <antonysaraev@gmail.com>
Cc: gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, jason@lakedaemon.net, jake@lwn.net
Subject: Re: [PATCH v2 05/06] staging: crypto: skein: rename macros
Message-ID: <20140519090839.GR15585@mwanda>
References: <cover.1399675444.git.antonysaraev@gmail.com>
 <2eac124c6a3815c72e91679c8cde729af712bb74.1399675445.git.antonysaraev@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2eac124c6a3815c72e91679c8cde729af712bb74.1399675445.git.antonysaraev@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 19, 2014 at 12:09:58PM +0400, Anton Saraev wrote:
> +/* ignore all asserts, for performance */
> +#define skein_assert_ret(x, ret_code)
> +#define skein_assert(x)

Not related to this patch, but defining away asserts like this is a bad
idea.  What if they have side affects like:

	skein_assert(foo++ == bar);

regards,
dan carpenter

