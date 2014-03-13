Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755236AbaCMUG0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2014 16:06:26 -0400
Received: from one.firstfloor.org ([193.170.194.197]:58854 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750983AbaCMUGZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2014 16:06:25 -0400
Date: Thu, 13 Mar 2014 21:06:23 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: Andi Kleen <andi@firstfloor.org>, acme@infradead.org, mingo@kernel.org,
        linux-kernel@vger.kernel.org, peterz@infradead.org, eranian@google.com,
        namhyung@kernel.org, Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 1/8] perf, tools: Add jsmn `jasmine' JSON parser
Message-ID: <20140313200623.GX22728@two.firstfloor.org>
References: <1394048978-15909-1-git-send-email-andi@firstfloor.org>
 <1394048978-15909-2-git-send-email-andi@firstfloor.org>
 <20140311133801.GD22678@krava.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140311133801.GD22678@krava.redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > +static char *mapfile(const char *fn, size_t *size)
> > +{
> > +	unsigned ps = sysconf(_SC_PAGESIZE);
> 
> you can use page_size instead

I decided not to do this as these are stand alone files.

-Andi
