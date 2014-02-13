Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754011AbaBMKpm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 05:45:42 -0500
Received: from isrv.corpit.ru ([86.62.121.231]:56772 "EHLO isrv.corpit.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752367AbaBMKpk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 05:45:40 -0500
Message-ID: <52FCA253.3030703@msgid.tls.msk.ru>
Date: Thu, 13 Feb 2014 14:45:39 +0400
From: Michael Tokarev <mjt@tls.msk.ru>
Organization: Telecom Service, JSC
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20131103 Icedove/17.0.10
MIME-Version: 1.0
To: Heiko Carstens <heiko.carstens@de.ibm.com>
CC: linux-kernel@vger.kernel.org, linux-390@vm.marist.edu,
        linux-s390@vger.kernel.org,
        Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: Re: [ANNOUNCE] s390 31 bit kernel support removal
References: <20140212092935.GA14964@osiris>
In-Reply-To: <20140212092935.GA14964@osiris>
X-Enigmail-Version: 1.5.1
OpenPGP: id=804465C5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

12.02.2014 13:29, Heiko Carstens wrote:
> We want to remove s390 31 bit kernel support with Linux kernel 3.16.

Maybe you can send a patch for Documentation/feature-removal-schedule.txt
about this now?

Thanks,

/mjt
