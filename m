Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753175AbaBNXel (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Feb 2014 18:34:41 -0500
Received: from merlin.infradead.org ([205.233.59.134]:57381 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752397AbaBNXej (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Feb 2014 18:34:39 -0500
Message-ID: <52FEA807.9040100@infradead.org>
Date: Fri, 14 Feb 2014 15:34:31 -0800
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Dan Carpenter <dan.carpenter@oracle.com>, Rob Landley <rob@landley.net>
CC: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Paul Bolle <pebolle@tiscali.nl>, devel@driverdev.osuosl.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [patch] Documentation/SubmittingPatches: Reported-by tags and
 permission
References: <20140214093001.GA15933@elgon.mountain>
In-Reply-To: <20140214093001.GA15933@elgon.mountain>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/14/2014 01:30 AM, Dan Carpenter wrote:
> The reported-by text says you have to ask for permission, but that's
> only if the bug was reported in private.  These days the standard is to
> always give reported-by credit or it's considered a bit rude.
> 
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

Acked-by: Randy Dunlap <rdunlap@infradead.org>

Thanks.

> diff --git a/Documentation/SubmittingPatches b/Documentation/SubmittingPatches
> index 26b1e31d5a13..f72ce7803b71 100644
> --- a/Documentation/SubmittingPatches
> +++ b/Documentation/SubmittingPatches
> @@ -432,12 +432,9 @@ have been included in the discussion
>  
>  14) Using Reported-by:, Tested-by:, Reviewed-by: and Suggested-by:
>  
> -If this patch fixes a problem reported by somebody else, consider adding a
> -Reported-by: tag to credit the reporter for their contribution.  Please
> -note that this tag should not be added without the reporter's permission,
> -especially if the problem was not reported in a public forum.  That said,
> -if we diligently credit our bug reporters, they will, hopefully, be
> -inspired to help us again in the future.
> +The Reported-by tag is to give credit to people who find bugs and report them.
> +Please note that if the bug was reported in private, then ask for permission
> +first before using the Reported-by tag.
>  
>  A Tested-by: tag indicates that the patch has been successfully tested (in
>  some environment) by the person named.  This tag informs maintainers that
> --


-- 
~Randy
