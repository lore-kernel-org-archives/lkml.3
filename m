Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754753AbaGVOI7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 10:08:59 -0400
Received: from mx1.redhat.com ([209.132.183.28]:6554 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750801AbaGVOI6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 10:08:58 -0400
Message-ID: <53CE7063.3090007@redhat.com>
Date: Tue, 22 Jul 2014 16:08:35 +0200
From: Maurizio Lombardi <mlombard@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Jens Axboe <axboe@kernel.dk>, Mike Qiu <qiudayu@linux.vnet.ibm.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "ming.lei@canonical.com" <ming.lei@canonical.com>,
        "dongsu.park@profitbricks.com" <dongsu.park@profitbricks.com>,
        "jet.chen@intel.com" <jet.chen@intel.com>,
        "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>,
        "hch@lst.de" <hch@lst.de>, "kmo@daterainc.com" <kmo@daterainc.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "axboe@fb.com" <axboe@fb.com>
Subject: Re: Bug_ON with patch: bio: modify __bio_add_page() to accept pages
 that don't start a new segment
References: <53C4E2F0.8000307@linux.vnet.ibm.com> <E83EB052-8DC9-4B0E-830D-AF7A2557BEF6@kernel.dk> <53C4E9F1.7070302@redhat.com> <53C620DD.7090700@redhat.com> <53C62F95.3020001@kernel.dk>
In-Reply-To: <53C62F95.3020001@kernel.dk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jens,

On 07/16/2014 09:53 AM, Jens Axboe wrote:
> 
> Sure, we can try again, hopefully this will be the last of them.
> 

I sent it, it must be applied on top of
"bio: modify __bio_add_page() to accept pages that don't start a new segment"

http://marc.info/?l=linux-kernel&m=140558697215009&w=2

I really hope this is the last fix to it.

Regards,
Maurizio Lombardi


