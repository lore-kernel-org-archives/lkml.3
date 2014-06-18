Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966483AbaFRMrs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 08:47:48 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:39322 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966140AbaFRMrq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 08:47:46 -0400
Date: Wed, 18 Jun 2014 14:47:43 +0200
From: Pavel Machek <pavel@ucw.cz>
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Cc: rjw@rjwysocki.net, rdunlap@infradead.org, viresh.kumar@linaro.org,
        linux-pm@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] PM / Documentation: Update copyright in
 suspend-and-cpuhotplug.txt
Message-ID: <20140618124742.GA5665@amd.pavel.ucw.cz>
References: <20140609123103.11086.12353.stgit@srivatsabhat.in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140609123103.11086.12353.stgit@srivatsabhat.in.ibm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> Extend the year to 2014 in the copyright.
> 
> Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>

The file was updated in 

commit 6237dd132d4eb408ffa80830fe395448e5657ab0
Author: Marcos Paulo de Souza <marcos.souza.org@gmail.com>
Date:   Wed May 2 14:33:37 2012 +0200

and by you in 2011:

commit 7fef9fc83fbd7293ea9fe665d14046422ebf4219
Author: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
Date:   Wed Oct 19 23:59:05 2011 +0200

So... copyright 2011 seems entirely correct.

									Pavel

> index e13dafc..2850df3 100644
> --- a/Documentation/power/suspend-and-cpuhotplug.txt
> +++ b/Documentation/power/suspend-and-cpuhotplug.txt
> @@ -1,6 +1,6 @@
>  Interaction of Suspend code (S3) with the CPU hotplug infrastructure
>  
> -     (C) 2011 Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
> +     (C) 2011 - 2014 Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
>  
>  
>  I. How does the regular CPU hotplug code differ from how the Suspend-to-RAM
> 


-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
