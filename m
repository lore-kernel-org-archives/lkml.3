Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756280AbaLWQE1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Dec 2014 11:04:27 -0500
Received: from mail-pa0-f51.google.com ([209.85.220.51]:47050 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755981AbaLWQE0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Dec 2014 11:04:26 -0500
Date: Tue, 23 Dec 2014 08:04:21 -0800
From: Jeremiah Mahler <jmmahler@gmail.com>
To: Gmail <kroderia@gmail.com>
Cc: gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] staging: skein: Delete a useless white space line
Message-ID: <20141223160421.GB13718@hudson.localdomain>
Mail-Followup-To: Jeremiah Mahler <jmmahler@gmail.com>,
	Gmail <kroderia@gmail.com>, gregkh@linuxfoundation.org,
	devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
References: <1419349073-6308-1-git-send-email-kroderia@gmail.com>
 <20141223155703.GA13718@hudson.localdomain>
 <897C311F-B3FF-4767-8D9C-22F534AA2E1E@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <897C311F-B3FF-4767-8D9C-22F534AA2E1E@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 24, 2014 at 12:01:10AM +0800, Gmail wrote:
> People say that is not a legal name, therefore I create this English name sound like my real name.
> 

I'm confused.  So Ben Chan isn't your real name, just one you made up?

> > On Dec 23, 2014, at 11:57 PM, Jeremiah Mahler <jmmahler@gmail.com> wrote:
> > 
> > On Tue, Dec 23, 2014 at 03:37:53PM +0000, Kroderia wrote:
> >> Signed-off-by: Ben Chan <kroderia@gmail.com <mailto:kroderia@gmail.com>>
> > 
> > Your Signed-off-by doesn't match your From: line.
> > 
> >> ---
> >> drivers/staging/skein/skein_generic.c |    1 -
> >> 1 file changed, 1 deletion(-)
> >> 
> >> diff --git a/drivers/staging/skein/skein_generic.c b/drivers/staging/skein/skein_generic.c
> >> index 85bd7d0..899078f 100644
> >> --- a/drivers/staging/skein/skein_generic.c
> >> +++ b/drivers/staging/skein/skein_generic.c
> >> @@ -191,7 +191,6 @@ static int __init skein_generic_init(void)
> >> 
> >> 	return 0;
> >> 
> >> -		
> >> unreg512:
> >> 	crypto_unregister_shash(&alg512);
> >> unreg256:
> >> -- 
> >> 1.7.10.4
> >> 
> >> --
> >> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> >> the body of a message to majordomo@vger.kernel.org <mailto:majordomo@vger.kernel.org>
> >> More majordomo info at  http://vger.kernel.org/majordomo-info.html <http://vger.kernel.org/majordomo-info.html>
> >> Please read the FAQ at  http://www.tux.org/lkml/ <http://www.tux.org/lkml/>
> > 
> > -- 
> > - Jeremiah Mahler
> 

-- 
- Jeremiah Mahler
