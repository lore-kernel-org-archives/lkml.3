Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752851AbaBJL7a (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 06:59:30 -0500
Received: from e06smtp16.uk.ibm.com ([195.75.94.112]:60967 "EHLO
	e06smtp16.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752484AbaBJL72 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 06:59:28 -0500
Date: Mon, 10 Feb 2014 12:59:23 +0100
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Sudeep Holla <Sudeep.Holla@arm.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        "linux390@de.ibm.com" <linux390@de.ibm.com>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>
Subject: Re: [PATCH RFC/RFT v2 3/8] s390: move cacheinfo sysfs to generic
 cacheinfo infrastructure
Message-ID: <20140210115923.GF19013@osiris>
References: <1391791763-28518-1-git-send-email-sudeep.holla@arm.com>
 <1391791763-28518-4-git-send-email-sudeep.holla@arm.com>
 <20140210095020.GB19013@osiris>
 <52F8B95F.5030401@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52F8B95F.5030401@arm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14021011-3548-0000-0000-000008037DAB
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 10, 2014 at 11:34:55AM +0000, Sudeep Holla wrote:
> On 10/02/14 09:50, Heiko Carstens wrote:
> > On Fri, Feb 07, 2014 at 04:49:18PM +0000, Sudeep Holla wrote:
> >> -		show_cacheinfo(m);
> >>  	}
> >>  	get_online_cpus();
> >>  	if (cpu_online(n)) {
> > 
> > You can't remove that. It's a user space visible change.
> > 
> Correct, I wanted to add show_cacheinfo back as its user ABI already, missed it.
> 
> Is it ok if I use cpu0 cacheinfo or to be safer as cpu0 can be offline, use
> the cacheinfo of the cpu executing this ?

Any online cpu would do, as the information is completely symmetrical.

