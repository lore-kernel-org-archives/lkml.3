Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752566Ab3EXEQh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 May 2013 00:16:37 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:50237 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752423Ab3EXEQf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 May 2013 00:16:35 -0400
Message-ID: <1369368994.2080.18.camel@joe-AO722>
Subject: Re: [PATCH 1/8] Documentation: Adding "The Perfect Patch" by Andrew
 Morton
From: Joe Perches <joe@perches.com>
To: Rob Landley <rob@landley.net>
Cc: Ben Minerds <puzzleduck@gmail.com>, greg@kroah.com,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Thu, 23 May 2013 21:16:34 -0700
In-Reply-To: <1369368624.2776.13@driftwood>
References: <1369368624.2776.13@driftwood>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-05-23 at 23:10 -0500, Rob Landley wrote:
> On 05/23/2013 07:49:53 AM, Ben Minerds wrote:
> >  Adding Andrews advice on patch submission and subdirectory for  
> > further patch
> >  documentstion.
> 
> You've seen Documentation/SubmittingPatches right?

Maybe not.

> > +- Ensure that your patch does not add new trailing whitespace.  The  
> > below
> > +  script will fix up your patch by stripping off such whitespace.
[]
> Doesn't scripts/checkpatch.pl check for this?

Yes it does.
scripts/cleanpatch exists too.


