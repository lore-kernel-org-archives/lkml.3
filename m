Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754308Ab3A0RLK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jan 2013 12:11:10 -0500
Received: from perches-mx.perches.com ([206.117.179.246]:49475 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753441Ab3A0RLJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jan 2013 12:11:09 -0500
Message-ID: <1359306667.14406.7.camel@joe-AO722>
Subject: Re: [PATCH] checkpatch.pl: Fix warnings on (networking specific)
 code comments
From: Joe Perches <joe@perches.com>
To: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Cc: apw@canonical.com, linux-kernel@vger.kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Date: Sun, 27 Jan 2013 09:11:07 -0800
In-Reply-To: <1359286539-18395-1-git-send-email-jeffrey.t.kirsher@intel.com>
References: <1359286539-18395-1-git-send-email-jeffrey.t.kirsher@intel.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2013-01-27 at 03:35 -0800, Jeff Kirsher wrote:
> This patch reverts a portion of the commit to allow multi-line code
> comments to use either style.
[]
> diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
[]
> @@ -1878,13 +1878,6 @@ sub process {
>  		}
>  
>  		if ($realfile =~ m@^(drivers/net/|net/)@ &&
> -		    $rawline =~ /^\+[ \t]*\/\*[ \t]*$/ &&
> -		    $prevrawline =~ /^\+[ \t]*$/) {
> -			WARN("NETWORKING_BLOCK_COMMENT_STYLE",
> -			     "networking block comments don't use an empty /* line, use /* Comment...\n" . $hereprev);
> -		}
> -
> -		if ($realfile =~ m@^(drivers/net/|net/)@ &&
>  		    $rawline !~ m@^\+[ \t]*\*/[ \t]*$@ &&	#trailing */
>  		    $rawline !~ m@^\+.*/\*.*\*/[ \t]*$@ &&	#inline /*...*/
>  		    $rawline !~ m@^\+.*\*{2,}/[ \t]*$@ &&	#trailing **/

Shrug.

Ignore things you don't agree with.

David has written many, many emails
requesting changes for this specific
comment style.

I think you and Intel should use
--ignore=NETWORKING_BLOCK_COMMENT_STYLE
to avoid seeing this if you don't agree
with it.

I also think expectations that everyone
will agree with every checkpatch bleat
are unrealistic.



