Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934029AbaDIS5X (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 14:57:23 -0400
Received: from prod-mail-xrelay07.akamai.com ([72.246.2.115]:12932 "EHLO
	prod-mail-xrelay07.akamai.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933143AbaDIS5W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 14:57:22 -0400
Message-ID: <5345980F.7070604@akamai.com>
Date: Wed, 09 Apr 2014 14:57:19 -0400
From: Jason Baron <jbaron@akamai.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>
CC: "Luck, Tony" <tony.luck@intel.com>, Aristeu Rozanski <aris@redhat.com>,
        "hpa@zytor.com" <hpa@zytor.com>, "mingo@kernel.org" <mingo@kernel.org>,
        "dougthompson@xmission.com" <dougthompson@xmission.com>,
        "m.chehab@samsung.com" <m.chehab@samsung.com>,
        "mitake@dcl.info.waseda.ac.jp" <mitake@dcl.info.waseda.ac.jp>,
        "linux-edac@vger.kernel.org" <linux-edac@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/3] ie31200_edac: Add driver
References: <cover.1396645124.git.jbaron@akamai.com> <760765424abe31811027ff3efd078bc858b7d3ed.1396645124.git.jbaron@akamai.com> <20140409113552.GJ6529@pd.tnic> <20140409133433.GJ29214@redhat.com> <3908561D78D1C84285E8C5FCA982C28F31E22EAC@ORSMSX106.amr.corp.intel.com> <20140409173633.GN6529@pd.tnic>
In-Reply-To: <20140409173633.GN6529@pd.tnic>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/09/2014 01:36 PM, Borislav Petkov wrote:
> On Wed, Apr 09, 2014 at 05:17:53PM +0000, Luck, Tony wrote:
>> The E3-12xx processors connect out to a different (desktop) chipset
>> from the E5 (server parts). Perhaps that means the memory controller
>> are different too???
> 
> You gotta love how Intel has a different memory controller for server
> and desktop parts. :-)
> 

Right, so maybe the fact that its a desktop chipset means that it behaves
differently and doesn't raise MCEs on memory errors. We have a bunch
of these processors and we haven't yet seen an MCE raised on a memory
error.

> Btw, is that the official memory controller name you'd like the edac
> driver to be called - ie31200? I'm asking because it should probably
> have a name which denotes the memory controller and not the processor
> series... (who knows, we might find that memory controller built in
> somewhere else :-))
> 
> Thanks.
> 

The reason I went with ie31200 is that afaiu the memory controller
hub is integrated into the cpu. Another alternative might be ie312xx?

Thanks,

-Jason

