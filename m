Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752530AbaA3EYZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jan 2014 23:24:25 -0500
Received: from mail-ob0-f180.google.com ([209.85.214.180]:60293 "EHLO
	mail-ob0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751782AbaA3EYX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jan 2014 23:24:23 -0500
Message-ID: <52E9D3EB.1060209@landley.net>
Date: Wed, 29 Jan 2014 22:24:11 -0600
From: Rob Landley <rob@landley.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Henrik Austad <henrik@austad.us>, LKML doc <linux-doc@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
CC: Jiri Kosina <jkosina@suse.cz>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>, Rob Herring <robh+dt@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Mark Brown <broonie@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Ingo Molnar <mingo@elte.hu>, Gleb Natapov <gleb@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Len Brown <len.brown@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        James Bottomley <JBottomley@parallels.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>
Subject: Re: [PATCH] Documentation cleanup, update 00-INDEX files in Documentation/
References: <1391041675-31683-1-git-send-email-henrik@austad.us>
In-Reply-To: <1391041675-31683-1-git-send-email-henrik@austad.us>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/29/14 18:27, Henrik Austad wrote:
> Some of the 00-INDEX files are somewhat outdated and some folders does not
> contain 00-INDEX at all. Only outdated (with the notably exception of
> spi) indexes are touched here, the 169 folders without 00-INDEX has not
> been touched.
>
> This applies to Linus' tip (0e47c969).

Looks like an improvement.

Acked-by: Rob Landley <rob@landley.net>

(My own scripts to find this stuff are based on maintaining 
http://kernel.org/doc and the kernel developers are no longer capable of 
providing rsync access to that, despite repeated requests. Most recently 
https://bugzilla.kernel.org/show_bug.cgi?id=52721 )

However, I'm curious about this bit:

> --- a/Documentation/00-INDEX
> +++ b/Documentation/00-INDEX
> @@ -1,11 +1,11 @@
>
> -This is a brief list of all the files in ./linux/Documentation and what
> -they contain. If you add a documentation file, please list it here in
> -alphabetical order as well, or risk being hunted down like a rabid dog.
> -Please keep the descriptions small enough to fit on one line.
> -							 Thanks -- Paul G.
> +# This is a brief list of all the files in ./linux/Documentation and what
> +# they contain. If you add a documentation file, please list it here in
> +# alphabetical order as well, or risk being hunted down like a rabid dog.
> +# Please keep the descriptions small enough to fit on one line.
> +# 							 Thanks -- Paul G.
>
> -Following translations are available on the WWW:
> +# Following translations are available on the WWW:

Is there a reason for that?

Rob
