Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936160AbaFIQIX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 12:08:23 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:42540 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933116AbaFIQIV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 12:08:21 -0400
Date: Mon, 9 Jun 2014 09:08:16 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Pranith Kumar <bobby.prani@gmail.com>
Cc: trivial@rustcorp.com.au, Dipankar Sarma <dipankar@in.ibm.com>,
        "open list:READ-COPY UPDATE..." <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/6] update reference, kerneltrap.org no longer works
Message-ID: <20140609160816.GC4581@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1402329088-4802-1-git-send-email-bobby.prani@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1402329088-4802-1-git-send-email-bobby.prani@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14060916-9332-0000-0000-0000010A54BD
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 09, 2014 at 11:51:23AM -0400, Pranith Kumar wrote:
> kerneltrap.org no longer works, update to a working reference
> 
> Signed-off-by: Pranith Kumar <bobby.prani@gmail.com>

Queued for 3.17, thank you!

FYI, I updated the commit message to read as follows:

------------------------------------------------------------------------

documentation: Update reference, kerneltrap.org no longer works

The kerneltrap.org site no longer works, so this commit updates it to 
a working reference, namely gmane.

Signed-off-by: Pranith Kumar <bobby.prani@gmail.com>

------------------------------------------------------------------------

I added the "documentation:" tag (as opposed to "rcu:" for core RCU code
or "rcutorture:" for RCU stress-test code) and capitalized the first word
of the subject line, and made a complete sentence out of the commit log.
No worries if you would rather not do this, but just FYI.

							Thanx, Paul

> ---
>  Documentation/RCU/RTFP.txt | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/Documentation/RCU/RTFP.txt b/Documentation/RCU/RTFP.txt
> index 2f0fcb2..f29bcbc 100644
> --- a/Documentation/RCU/RTFP.txt
> +++ b/Documentation/RCU/RTFP.txt
> @@ -2451,8 +2451,8 @@ lot of {Linux} into your technology!!!"
>  ,month="February"
>  ,year="2010"
>  ,note="Available:
> -\url{http://kerneltrap.com/mailarchive/linux-netdev/2010/2/26/6270589}
> -[Viewed March 20, 2011]"
> +\url{http://thread.gmane.org/gmane.linux.network/153338}
> +[Viewed June 9, 2014]"
>  ,annotation={
>  	Use a pair of list_head structures to support RCU-protected
>  	resizable hash tables.
> -- 
> 1.9.1
> 

