Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755121AbaKEP7Q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 10:59:16 -0500
Received: from a.ns.miles-group.at ([95.130.255.143]:65275 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754898AbaKEP7P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 10:59:15 -0500
Message-ID: <545A4947.4030403@nod.at>
Date: Wed, 05 Nov 2014 16:59:03 +0100
From: Richard Weinberger <richard@nod.at>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.0
MIME-Version: 1.0
To: dedekind1@gmail.com
CC: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
        tlinder@codeaurora.org
Subject: Re: [PATCH 06/35] UBI: Fastmap: Ensure that all fastmap work is done
 upon WL shutdown
References: <1414586758-9972-1-git-send-email-richard@nod.at>		 <1414586758-9972-7-git-send-email-richard@nod.at>	 <1415202307.958.125.camel@sauron.fi.intel.com> <545A46F0.7030805@nod.at> <1415202877.958.131.camel@sauron.fi.intel.com>
In-Reply-To: <1415202877.958.131.camel@sauron.fi.intel.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 05.11.2014 um 16:54 schrieb Artem Bityutskiy:
> On Wed, 2014-11-05 at 16:49 +0100, Richard Weinberger wrote:
>> If you want I can rebase.
> 
> That would be very helpful.
> 
>> I did all fixes first and then the cleanups.
> 
> Well, the first patch adds debugging stuff - not exactly a fix ;-)

Let's name it robustness stuff. ;)
Seriously, I did first all fixes and the code cleanups later to make
it easy for others to backport these fixes.

Thanks,
//richard
