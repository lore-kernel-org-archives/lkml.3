Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753884Ab3KEJAM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Nov 2013 04:00:12 -0500
Received: from e06smtp18.uk.ibm.com ([195.75.94.114]:39204 "EHLO
	e06smtp18.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750990Ab3KEJAL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Nov 2013 04:00:11 -0500
Subject: Re: [PATCH 2/9] GenWQE: Remove option to select name
From: Frank Haverkamp <haver@linux.vnet.ibm.com>
Reply-To: haver@linux.vnet.ibm.com
To: Ryan Mallon <rmallon@gmail.com>
Cc: linux-kernel@vger.kernel.org, arnd@arndb.de, gregkh@linuxfoundation.org,
        cody@linux.vnet.ibm.com, schwidefsky@de.ibm.com, utz.bacher@de.ibm.com,
        mmarek@suse.cz, jsvogt@de.ibm.com, MIJUNG@de.ibm.com,
        cascardo@linux.vnet.ibm.com, michael@ibmra.de
In-Reply-To: <527817CF.7020304@gmail.com>
References: <1383584889-21594-1-git-send-email-haver@linux.vnet.ibm.com>
	 <1383584889-21594-3-git-send-email-haver@linux.vnet.ibm.com>
	 <527817CF.7020304@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Organization: IBM
Date: Tue, 05 Nov 2013 10:00:01 +0100
Message-ID: <1383642001.15859.1.camel@oc7383187364.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-30.el6) 
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13110509-6892-0000-0000-000006CE13C5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ryan,

Am Dienstag, den 05.11.2013, 08:55 +1100 schrieb Ryan Mallon:
> On 05/11/13 04:08, Frank Haverkamp wrote:
> > Selecting interface names via configuration option is obsolete.
> 
> Don't do this. You are adding completely new code, so there is no reason
> to post a patch full of code that is known to be incorrect, followed by
> a set of patches fixing things. Just post the correct code to start
> with. This makes the git history cleaner, and makes the code easier to
> review.

Agreed.

> You can use tools like git interactive rebase to split your work into
> multiple patches. It should be quite easy for this because you mostly
> just want to break down things to the file level, so even:
> 
>   git reset --soft <your-first-commit>
> 
> and then manually staging and commiting things from there would probably
> be enough. You can use git add --interactive to stage individual file
> hunks if you want to break things down further.

I have sent "Generic WorkQueue Engine (GenWQE) device driver (v6)" now
which hopefully is what you wanted.

Regards

Frank

