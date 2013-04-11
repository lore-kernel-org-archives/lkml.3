Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936677Ab3DKDrS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 23:47:18 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:48055 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S934484Ab3DKDrR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 23:47:17 -0400
Message-ID: <1365652023.13308.1.camel@joe-AO722>
Subject: Re: [PATCH] checkpatch: Warn on comparisons to true and false
From: Joe Perches <joe@perches.com>
To: Dave Jones <davej@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Andy Whitcroft <apw@shadowen.org>, LKML <linux-kernel@vger.kernel.org>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>
Date: Wed, 10 Apr 2013 20:47:03 -0700
In-Reply-To: <20130411021415.GA16118@redhat.com>
References: <1365563834.27174.12.camel@joe-AO722>
	 <20130410155751.7ecc6738d616fb8771991ce1@linux-foundation.org>
	 <20130411021415.GA16118@redhat.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-04-10 at 22:14 -0400, Dave Jones wrote:
> It would be interesting to see how many people have historically screwed 
> up and used (!a) when they mean (a) and vice versa, versus spelling
> it out longform.  I'd be surprised if the results weren't skewed
> in favour of the more verbose form.

I think it'd be interesting too though I'd
take the other side.

