Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757636Ab3DHHY1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 03:24:27 -0400
Received: from ozlabs.org ([203.10.76.45]:33361 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934440Ab3DHHYZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 03:24:25 -0400
Date: Mon, 8 Apr 2013 17:24:22 +1000
From: Michael Ellerman <michael@ellerman.id.au>
To: acme@infradead.org
Cc: peterz@infradead.org, jolsa@redhat.com, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, rob@landley.net
Subject: Re: [RFC/PATCH] perf: Expand definition of sysfs format attribute
Message-ID: <20130408072422.GA4476@concordia>
References: <1362370865-4437-1-git-send-email-michael@ellerman.id.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1362370865-4437-1-git-send-email-michael@ellerman.id.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 04, 2013 at 03:21:05PM +1100, Michael Ellerman wrote:
> Make it explicit that the format attributes may define overlapping bit
> ranges. Unfortunately this was left unspecified originally, and all the
> examples show non-overlapping ranges. I don't believe this is an ABI
> change, as we are defining something that was previously undefined, but
> others may disagree.
> 
> The POWER8 PMU would like to define overlapping ranges, as bit ranges in
> the event code have different meanings for certain events. It will also
> allow us to define an overarching "event" field, that encompasses all
> others.
> 
> As far as I can see perf is comfortable with this change, however I am
> not sure if there are any other users of the interface.

Any comments on this one?

cheers
