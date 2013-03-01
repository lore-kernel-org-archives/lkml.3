Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755248Ab3CAUU3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Mar 2013 15:20:29 -0500
Received: from cpsmtpb-ews05.kpnxchange.com ([213.75.39.8]:64460 "EHLO
	cpsmtpb-ews05.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752712Ab3CAUU1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Mar 2013 15:20:27 -0500
Message-ID: <1362169225.20156.6.camel@x61.thuisdomein>
Subject: Re: [PATCH V2] MAINTAINERS: Update SIMTEC file patterns, remove
 Vincent Sanders
From: Paul Bolle <pebolle@tiscali.nl>
To: Joe Perches <joe@perches.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Simtec Linux Team <linux@simtec.co.uk>,
        Ben Dooks <ben-linux@fluff.org>
Date: Fri, 01 Mar 2013 21:20:25 +0100
In-Reply-To: <1362168132.2116.17.camel@joe-AO722>
References: <1362166088.2116.10.camel@joe-AO722>
	 <1362168132.2116.17.camel@joe-AO722>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 01 Mar 2013 20:20:25.0769 (UTC) FILETIME=[3580E190:01CE16BA]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-03-01 at 12:02 -0800, Joe Perches wrote:
> commit 85fd6d6 ("ARM: S3C2410: move mach-s3c2410/* into mach-s3c24xx/")
> moved the files, update the F: patterns.

The BAST MAINTAINER entry has come up a few times already. I commented
on the last time that happened in https://lkml.org/lkml/2012/11/24/96 .
Nothing has changed. I suggest to remove this entry entirely.

I guess the CATS entry might also be removed. But that doesn't have an
F: pattern, so I'm not sure what code that entry covers.


Paul Bolle

