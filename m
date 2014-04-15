Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754550AbaDOTrJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 15:47:09 -0400
Received: from qmta11.emeryville.ca.mail.comcast.net ([76.96.27.211]:44640
	"EHLO qmta11.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751006AbaDOTrI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 15:47:08 -0400
Date: Tue, 15 Apr 2014 14:47:05 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Vince Weaver <vincent.weaver@maine.edu>
cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Michal Marek <mmarek@suse.cz>, linux-kernel@vger.kernel.org,
        Jason Cooper <jason@lakedaemon.net>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>
Subject: Re: [bisected] broken make-kpkg kernel build in 3.15-rc1
In-Reply-To: <alpine.DEB.2.10.1404151507290.15528@vincent-weaver-1.um.maine.edu>
Message-ID: <alpine.DEB.2.10.1404151442380.29234@gentwo.org>
References: <alpine.DEB.2.10.1404150940250.14106@vincent-weaver-1.um.maine.edu> <534D4A59.6080401@suse.cz> <alpine.DEB.2.10.1404151146530.26562@gentwo.org> <534D6510.3070509@suse.cz> <alpine.DEB.2.10.1404151221360.26992@gentwo.org> <20140415182653.GR24070@n2100.arm.linux.org.uk>
 <alpine.DEB.2.10.1404151507290.15528@vincent-weaver-1.um.maine.edu>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 15 Apr 2014, Vince Weaver wrote:

> > Then run the same thing with the commit reverted, again logging it.  Then
> > diff the two and see what's different.
>
> OK, I captured the output.  No diffs, as of course reverting things
> means one kernel was called 3.15-rc1 and one 3.15-rc1+ which meant more or
> less every line changed.

Well just add another fake patch and they both will have the same name...
The diff would be very helpful.

