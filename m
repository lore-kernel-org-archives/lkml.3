Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751868AbaLOKN0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 05:13:26 -0500
Received: from mail.skyhub.de ([78.46.96.112]:39030 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750865AbaLOKNW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 05:13:22 -0500
Date: Mon, 15 Dec 2014 11:13:19 +0100
From: Borislav Petkov <bp@alien8.de>
To: Kevin Cernekee <cernekee@gmail.com>
Cc: tglx@linutronix.de, gnomes@lxorguk.ukuu.org.uk,
        computersforpeace@gmail.com, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, corbet@lwn.net, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC 4/4] Documentation: Provide suggestions on when to repost
 patches
Message-ID: <20141215101319.GA6444@pd.tnic>
References: <1418623790-28429-1-git-send-email-cernekee@gmail.com>
 <1418623790-28429-5-git-send-email-cernekee@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1418623790-28429-5-git-send-email-cernekee@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 14, 2014 at 10:09:50PM -0800, Kevin Cernekee wrote:
> Give submitters a rough idea of how long to wait before reposting, to
> help avoid situations where a series is reposted before the original
> submission is fully reviewed.
> 
> Suggested-by: Thomas Gleixner <tglx@linutronix.de>
> Signed-off-by: Kevin Cernekee <cernekee@gmail.com>
> ---
>  Documentation/development-process/6.Followthrough | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/Documentation/development-process/6.Followthrough b/Documentation/development-process/6.Followthrough
> index 41d324a..6cefb6c 100644
> --- a/Documentation/development-process/6.Followthrough
> +++ b/Documentation/development-process/6.Followthrough
> @@ -74,7 +74,10 @@ around.
>  One fatal mistake is to ignore review comments in the hope that they will
>  go away.  They will not go away.  If you repost code without having
>  responded to the comments you got the time before, you're likely to find
> -that your patches go nowhere.
> +that your patches go nowhere.  On the flipside, reposting an updated patch
> +before the original has been fully reviewed can be a source of frustration
> +too,

I'd like to make that aspect stronger/more explicit:

"Please do repost only after the reviewers have finished going through
your submission and you have collected, addressed and/or incorporated
their full feedback. You can use the time while waiting to test and
hammer more on your code. Any non-trivial submission of a patchset
should be resent after a full week (7 days) the earliest in order not to
spam people unnecessarily and to give them a chance to at least finish
reviewing."

Anyway, something like that, formulation might need more cleaning up - I
was just trying to express the sentiment...

> so consider giving the reviewers ~3-7 calendar days (depending on
> +patch complexity) before posting V2.
>  
>  Speaking of reposting code: please bear in mind that reviewers are not
>  going to remember all the details of the code you posted the last time

Thanks for doing this, btw!

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
