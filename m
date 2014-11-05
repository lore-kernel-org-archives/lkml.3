Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755949AbaKEQFe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 11:05:34 -0500
Received: from a.ns.miles-group.at ([95.130.255.143]:65275 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755148AbaKEQFd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 11:05:33 -0500
Message-ID: <545A4ACA.2070402@nod.at>
Date: Wed, 05 Nov 2014 17:05:30 +0100
From: Richard Weinberger <richard@nod.at>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.0
MIME-Version: 1.0
To: dedekind1@gmail.com
CC: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
        tlinder@codeaurora.org
Subject: Re: [PATCH 03/35] UBI: Fastmap: Add self check to detect absent PEBs
References: <1414586758-9972-1-git-send-email-richard@nod.at>		 <1414586758-9972-4-git-send-email-richard@nod.at>	 <1415201029.958.118.camel@sauron.fi.intel.com> <545A48BD.9010904@nod.at> <1415203295.958.133.camel@sauron.fi.intel.com>
In-Reply-To: <1415203295.958.133.camel@sauron.fi.intel.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 05.11.2014 um 17:01 schrieb Artem Bityutskiy:
> On Wed, 2014-11-05 at 16:56 +0100, Richard Weinberger wrote:
>>  I did that to have alloc and free balanced.
>> I.e. to not have a naked kfree(). Always when I see a kfree()
>> somewhere
>> I'd like to see the k*alloc().
> 
> OK. Please, just make the comment simpler then. Say that you are freeing
> the debugging buffer or something.

Will do!

Thanks,
//richard
