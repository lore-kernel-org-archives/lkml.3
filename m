Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752147Ab3HUAWj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 20:22:39 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:51197 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751979Ab3HUAWh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 20:22:37 -0400
Message-ID: <1377044556.2016.102.camel@joe-AO722>
Subject: Re: rfc: trivial patches and slow deaths?
From: Joe Perches <joe@perches.com>
To: Rob Landley <rob@landley.net>
Cc: Andrew Morton <akpm@linux-foundation.org>, Jiri Kosina <jkosina@suse.cz>,
        LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors <kernel-janitors@vger.kernel.org>
Date: Tue, 20 Aug 2013 17:22:36 -0700
In-Reply-To: <1377043822.2737.86@driftwood>
References: <1377043822.2737.86@driftwood>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-08-20 at 19:10 -0500, Rob Landley wrote:
> The important question is does he want to handle patches that you're  
> flipping out about not going in before the next merge window because  
> they are SO IMPORTANT that the trivial tree must promote them out of  
> sequence.

You're misreading.  I see no flipping out here.

I'm simply saying that obvious defects should be
corrected sooner rather than later.

I'm also saying that the trivial tree should
have some visibility about whether or not a
patch or series will be handled by the trivial
maintainer or not.

Jiri has not responded to this point.

Silence about the status of patches that extends
for months is not good.


