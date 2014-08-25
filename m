Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753528AbaHYJ7E (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2014 05:59:04 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:31512 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751540AbaHYJ7B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2014 05:59:01 -0400
Date: Mon, 25 Aug 2014 12:58:48 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Janet Liu <janetliu526@qq.com>
Cc: gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging:lustre:lnet: lib-md.c fix checkpath warnings and
 errors.
Message-ID: <20140825095848.GC5046@mwanda>
References: <1408902090-8397-1-git-send-email-janetliu526@qq.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1408902090-8397-1-git-send-email-janetliu526@qq.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 25, 2014 at 01:41:29AM +0800, Janet Liu wrote:
> Sliences the following warning and error:
> 
>   WARNING: line over 80 characters
>   WARNING: space prohibited between function name and open parenthesis '('
>   ERROR: do not use C99 // comments
>   ERROR: trailing statements should be on next line
> 
> Signed-off-by: Janet Liu <janetliu526@qq.com>

This breaks the build.

regards,
dan carpenter

