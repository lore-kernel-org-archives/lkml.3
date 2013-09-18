Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751787Ab3IRFtk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Sep 2013 01:49:40 -0400
Received: from cantor2.suse.de ([195.135.220.15]:55451 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751351Ab3IRFti (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Sep 2013 01:49:38 -0400
Message-ID: <52393EEF.10705@suse.de>
Date: Wed, 18 Sep 2013 07:49:35 +0200
From: Hannes Reinecke <hare@suse.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Paul Bolle <pebolle@tiscali.nl>
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, Doug Ledford <dledford@redhat.com>,
        "James E.J. Bottomley" <JBottomley@parallels.com>,
        Josh Boyer <jwboyer@redhat.com>
Subject: Re: scsi: delete decade+ obsolete aic7xxx_old driver
References: <1379382683-27862-1-git-send-email-paul.gortmaker@windriver.com> <1379442463.31104.11.camel@x220.thuisdomein>
In-Reply-To: <1379442463.31104.11.camel@x220.thuisdomein>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/17/2013 08:27 PM, Paul Bolle wrote:
> On Mon, 2013-09-16 at 21:51 -0400, Paul Gortmaker wrote:
>> Currently we have people wasting time building it during routine testing,
>> and then wasting more time re-researching the known reported warnings,
>> only to find that nobody really is willing to integrate the fixes[3] for
>> it.
>>
>> [...]
>>
>> [3] https://lkml.org/lkml/2012/10/29/215
> 
> Well, this didn't end up as an entire waste of my time. After that
> message I sent a patch to Fedora's kernel list, and a reminder a few
> months later[1]. That prompted Josh Boyer to remove this old driver from
> the Fedora build[2].
> 
> And now that driver is disabled in all kernels that Fedora currently
> ships. I'm not familiar with any complaints about this decision.
> 
Ok, good to know.
So this patch appears to be good, then.

Acked-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: J. Hawn, J. Guild, F. Imendörffer, HRB 16746 (AG Nürnberg)
