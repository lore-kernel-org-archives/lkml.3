Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932981Ab3GCOGU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 10:06:20 -0400
Received: from cantor2.suse.de ([195.135.220.15]:34927 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932916Ab3GCOEi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 10:04:38 -0400
Message-ID: <51D42F71.9030701@suse.cz>
Date: Wed, 03 Jul 2013 16:04:33 +0200
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Nicolas Palix <nicolas.palix@imag.fr>
Cc: Coccinelle <cocci@systeme.lip6.fr>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [Cocci] [PATCH 3/3] Coccinelle: Update the options used to the
 new option scheme
References: <1371726656-24928-1-git-send-email-nicolas.palix@imag.fr> <1371726656-24928-2-git-send-email-nicolas.palix@imag.fr> <51D428F4.6020003@suse.cz> <CAAxaTiMgaCp17um0NnF2gbWDoRZnb2GOq-50LRAvV_dDdEsjRg@mail.gmail.com>
In-Reply-To: <CAAxaTiMgaCp17um0NnF2gbWDoRZnb2GOq-50LRAvV_dDdEsjRg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 3.7.2013 15:52, Nicolas Palix wrote:
> Hi,
> 
> On Wed, Jul 3, 2013 at 3:36 PM, Michal Marek <mmarek@suse.cz> wrote:
>> On 20.6.2013 13:10, Nicolas Palix wrote:
>>> spatch has changed its option scheme.
>>> E.g., --no_show_diff is now --no-show-diff
>>>
>>> This patch updates:
>>>  - scripts/coccicheck
>>>  - Semantic patches under scripts/coccinelle/
>>
>> Will the new syntax work with older spatch versions?
>> I mean, it's
>> probably fair to require a recent version, but it should be documented IMO.
> 
> It is the opposite. The new spatch still supports the old
> naming scheme. The more conventional naming has been introduced
> in spatch version 1.0.0-rc11 in March 2012. I will send a new patch to
> document that point.

Thanks.


>> Also, there was no patch 2/3 in this series, only 1/3 and 3/3.
> 
> It seems you finally found the v2 of this one. :)

Yes :).

Michal

