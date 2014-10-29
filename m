Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934255AbaJ2Pui (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 11:50:38 -0400
Received: from mail-oi0-f50.google.com ([209.85.218.50]:37582 "EHLO
	mail-oi0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933822AbaJ2Pug (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 11:50:36 -0400
Message-ID: <54510CD2.2070101@landley.net>
Date: Wed, 29 Oct 2014 10:50:42 -0500
From: Rob Landley <rob@landley.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Dan Carpenter <dan.carpenter@oracle.com>, Jonathan Corbet <corbet@lwn.net>
CC: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Paul Bolle <pebolle@tiscali.nl>, devel@driverdev.osuosl.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [patch v2] Documentation/SubmittingPatches: Reported-by tags
 and permission
References: <20141029100136.GA14718@mwanda>
In-Reply-To: <20141029100136.GA14718@mwanda>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/29/14 05:01, Dan Carpenter wrote:
> The reported-by text says you have to ask for permission, but that
> should only be if the bug was reported in private.  These days the
> standard is to always give reported-by credit or it's considered a bit
> rude.
> 
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> 
> diff --git a/Documentation/SubmittingPatches b/Documentation/SubmittingPatches
> index 482c749..1fa1caa 100644
> --- a/Documentation/SubmittingPatches
> +++ b/Documentation/SubmittingPatches
> @@ -483,12 +483,10 @@ have been included in the discussion
>  
>  14) Using Reported-by:, Tested-by:, Reviewed-by:, Suggested-by: and Fixes:
>  
> -If this patch fixes a problem reported by somebody else, consider adding a
> -Reported-by: tag to credit the reporter for their contribution.  Please
> -note that this tag should not be added without the reporter's permission,
> -especially if the problem was not reported in a public forum.  That said,
> -if we diligently credit our bug reporters, they will, hopefully, be
> -inspired to help us again in the future.
> +The Reported-by tag gives credit to people who find bugs and report them and it
> +hopefully inspires them to help us again in the future.  Please note that if
> +the bug was reported in private, then ask for permission first before using the
> +Reported-by tag.
>  
>  A Tested-by: tag indicates that the patch has been successfully tested (in
>  some environment) by the person named.  This tag informs maintainers that

Nitpick: no colon at end of tag name?

Rob

