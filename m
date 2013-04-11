Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934470Ab3DKI3j (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 04:29:39 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:41739 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753464Ab3DKI3h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 04:29:37 -0400
Message-ID: <1365668975.1929.4.camel@joe-AO722>
Subject: Re: [PATCH] checkpatch: Warn on comparisons to true and false
From: Joe Perches <joe@perches.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Dave Jones <davej@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
        Andy Whitcroft <apw@shadowen.org>, LKML <linux-kernel@vger.kernel.org>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>
Date: Thu, 11 Apr 2013 01:29:35 -0700
In-Reply-To: <20130411081943.GA6772@mwanda>
References: <1365563834.27174.12.camel@joe-AO722>
	 <20130410155751.7ecc6738d616fb8771991ce1@linux-foundation.org>
	 <20130411021415.GA16118@redhat.com> <20130411081943.GA6772@mwanda>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-04-11 at 11:19 +0300, Dan Carpenter wrote:
> On Wed, Apr 10, 2013 at 10:14:15PM -0400, Dave Jones wrote:
> > It would be interesting to see how many people have historically screwed 
> > up and used (!a) when they mean (a) and vice versa, versus spelling
> > it out longform.  I'd be surprised if the results weren't skewed
> > in favour of the more verbose form.
> 
> I see a the occasional reversed test in Smatch but normally these
> kind of bugs are detected with basic testing so they are rare.

I'd guess the most common error would be using
an int comparison when the value is not 0 or 1.

Non-zero is still "true" but isn't == true.


