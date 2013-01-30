Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753677Ab3A3PdA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2013 10:33:00 -0500
Received: from e8.ny.us.ibm.com ([32.97.182.138]:36659 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751042Ab3A3Pc7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2013 10:32:59 -0500
Message-ID: <51093D03.8070006@linux.vnet.ibm.com>
Date: Wed, 30 Jan 2013 07:32:19 -0800
From: Dave Hansen <dave@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Pavel Machek <pavel@ucw.cz>
CC: paul.szabo@sydney.edu.au, 695182@bugs.debian.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [RFC] Reproducible OOM with just a few sleeps
References: <201301142036.r0EKaYGN005907@como.maths.usyd.edu.au> <50F4A92F.2070204@linux.vnet.ibm.com> <20130130125151.GB19069@amd.pavel.ucw.cz>
In-Reply-To: <20130130125151.GB19069@amd.pavel.ucw.cz>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13013015-9360-0000-0000-00000FE83DB6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/30/2013 04:51 AM, Pavel Machek wrote:
> Are you saying that HIGHMEM configuration with 4GB ram is not expected
> to work?

Not really.

The assertion was that 4GB with no PAE passed a forkbomb test (ooming)
while 4GB of RAM with PAE hung, thus _PAE_ is broken.

