Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760791Ab3DDNAa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Apr 2013 09:00:30 -0400
Received: from cpsmtpb-ews07.kpnxchange.com ([213.75.39.10]:55254 "EHLO
	cpsmtpb-ews07.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760159Ab3DDNA1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Apr 2013 09:00:27 -0400
Message-ID: <1365080383.1830.46.camel@x61.thuisdomein>
Subject: Re: [PATCH] Blackfin: bf537: rename "CONFIG_ADT75"
From: Paul Bolle <pebolle@tiscali.nl>
To: Guenter Roeck <linux@roeck-us.net>
Cc: Jean Delvare <khali@linux-fr.org>, Mike Frysinger <vapier@gentoo.org>,
        Michael Hennerich <michael.hennerich@analog.com>,
        Jonathan Cameron <jic23@cam.ac.uk>,
        uclinux-dist-devel@blackfin.uclinux.org, linux-kernel@vger.kernel.org
Date: Thu, 04 Apr 2013 14:59:43 +0200
In-Reply-To: <20130404120734.GA23162@roeck-us.net>
References: <1365071466.1830.29.camel@x61.thuisdomein>
	 <20130404134003.016dcee3@endymion.delvare>
	 <20130404120734.GA23162@roeck-us.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 04 Apr 2013 12:59:43.0389 (UTC) FILETIME=[46A964D0:01CE3134]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-04-04 at 05:07 -0700, Guenter Roeck wrote:
> On Thu, Apr 04, 2013 at 01:40:03PM +0200, Jean Delvare wrote: 
> > This breakage is telling us something about the weird approach taken in
> > this file, methinks.
> > 
> Yes, they have persistent problems with renamed or moved drivers. I somewhat
> understood the need for SPI chips, but even there it seemed to me there should
> be a better solution.

The output of the (local) scripts I use mention about a dozen more
(possible) problems in both Blackfin's stamp.c files. I'm roughly
working my way back in git history, slowly, so those problems are
probably older.

Since I know from previous cleaning up efforts that the Blackfin people
know they have non-working code (eg, code not actually buildable since
it has no working Kconfig support) I do not give Blackfin much priority.
But this patch (and the other two related to the v3.2 release) were
obvious oversights that I could as well fix right away.


Paul Bolle

