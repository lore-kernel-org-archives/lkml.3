Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752237AbaBIWLb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Feb 2014 17:11:31 -0500
Received: from cpsmtpb-ews03.kpnxchange.com ([213.75.39.6]:56830 "EHLO
	cpsmtpb-ews03.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751691AbaBIWLa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Feb 2014 17:11:30 -0500
Message-ID: <1391983888.25855.73.camel@x220>
Subject: Re: [PATCH 24/28] Remove DEPRECATED
From: Paul Bolle <pebolle@tiscali.nl>
To: Gene Heskett <gheskett@wdtv.com>
Cc: Richard Weinberger <richard@nod.at>, Guenter Roeck <linux@roeck-us.net>,
        David Howells <dhowells@redhat.com>,
        Koichi Yasutake <yasutake.koichi@jp.panasonic.com>,
        "moderated list:PANASONIC MN10300..." <linux-am33-list@redhat.com>,
        open list <linux-kernel@vger.kernel.org>
Date: Sun, 09 Feb 2014 23:11:28 +0100
In-Reply-To: <201402091654.25697.gheskett@wdtv.com>
References: <1391971686-9517-1-git-send-email-richard@nod.at>
	 <52F7F486.7040003@roeck-us.net> <52F7F54B.3050602@nod.at>
	 <201402091654.25697.gheskett@wdtv.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.3 (3.10.3-1.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 09 Feb 2014 22:11:28.0965 (UTC) FILETIME=[E197A750:01CF25E3]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2014-02-09 at 16:54 -0500, Gene Heskett wrote:
> And much of it is in a bad make oldconfig that I can't date, but all of the 
> multimedia stuff has been stripped and I can no longer use my pcHDTV3000 
> card as just one for instance.  I just tested it, using an oldconfig that 
> contained several hundred bits and pieces under the ATSC & DVB headers,  
> after the oldconfig was done, all that was stripped from the new one, every 
> trace of it.  That was working code guys, what the hell?  Kconfig could 
> have problems, but the oldconfig output being stripped is a much larger 
> one.  First problems first.  Then you can really see how fubared kconfig 
> is.

What has this got to do with an invalid Kconfig dependency in
arch/mn10300?


Paul Bolle


