Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754098Ab3FFTvZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jun 2013 15:51:25 -0400
Received: from webmail.solarflare.com ([12.187.104.25]:24397 "EHLO
	webmail.solarflare.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751818Ab3FFTvX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jun 2013 15:51:23 -0400
Message-ID: <1370548278.4757.2.camel@bwh-desktop.uk.level5networks.com>
Subject: Re: mmotm 2013-06-05-17-24 uploaded (ptp_pch)
From: Ben Hutchings <bhutchings@solarflare.com>
To: Randy Dunlap <rdunlap@infradead.org>
CC: <akpm@linux-foundation.org>, <linux-kernel@vger.kernel.org>,
        <linux-next@vger.kernel.org>,
        Richard Cochran <richardcochran@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Date: Thu, 6 Jun 2013 20:51:18 +0100
In-Reply-To: <51B011F0.6050805@infradead.org>
References: <20130606002636.6746F5A41AE@corp2gmr1-2.hot.corp.google.com>
	 <51B011F0.6050805@infradead.org>
Organization: Solarflare
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.17.20.137]
X-TM-AS-Product-Ver: SMEX-10.0.0.1412-7.000.1014-19918.005
X-TM-AS-Result: No--31.963000-0.000000-31
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-06-05 at 21:37 -0700, Randy Dunlap wrote:
> On 06/05/13 17:26, akpm@linux-foundation.org wrote:
> > The mm-of-the-moment snapshot 2013-06-05-17-24 has been uploaded to
> > 
> >    http://www.ozlabs.org/~akpm/mmotm/
> > 
> > mmotm-readme.txt says
> > 
> > README for mm-of-the-moment:
> > 
> > http://www.ozlabs.org/~akpm/mmotm/
> > 
> 
> on i386:  when CONFIG_PCI is not enabled:
> 
> drivers/ptp/ptp_pch.c:710:1: warning: data definition has no type or storage class [enabled by default]
> drivers/ptp/ptp_pch.c:710:1: warning: type defaults to 'int' in declaration of 'module_pci_driver' [-Wimplicit-int]
> drivers/ptp/ptp_pch.c:710:1: warning: parameter names (without types) in function declaration [enabled by default]
> drivers/ptp/ptp_pch.c:701:26: warning: 'pch_driver' defined but not used [-Wunused-variable]

Right, it should depend on CONFIG_PCI.  Previously reported in
<http://thread.gmane.org/gmane.linux.network/270531> but there was then
some confusion about whether it was s390 breakage (which it isn't).

Ben.

-- 
Ben Hutchings, Staff Engineer, Solarflare
Not speaking for my employer; that's the marketing department's job.
They asked us to note that Solarflare product names are trademarked.

