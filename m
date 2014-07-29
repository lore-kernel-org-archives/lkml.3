Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754643AbaG2XZz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 19:25:55 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:38848 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750926AbaG2XZx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 19:25:53 -0400
Message-ID: <53D82D7D.4030903@gmail.com>
Date: Wed, 30 Jul 2014 01:25:49 +0200
From: poma <pomidorabelisima@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.7.0
MIME-Version: 1.0
To: Christoph Hellwig <hch@lst.de>,
        James Bottomley <James.Bottomley@HansenPartnership.com>
CC: Vladimir Davydov <vdavydov@parallels.com>,
        Linux Kernel list <linux-kernel@vger.kernel.org>,
        Christoph Lameter <cl@linux.com>,
        Mailing-List fedora-kernel <kernel@lists.fedoraproject.org>,
        Paolo Bonzini <pbonzini@redhat.com>, linux-scsi@vger.kernel.org
Subject: Re: WARNING: CPU: 1 PID: 495 at mm/slab_common.c:69 kmem_cache_create+0x1a9/0x330()
References: <53C8DF7F.5060707@gmail.com> <53C8FD95.5020302@gmail.com> <20140718132104.GK27940@esperanza> <20140718141747.GA23272@lst.de> <53C97D34.5040707@gmail.com> <1405714046.30262.10.camel@dabdike.int.hansenpartnership.com> <20140719164454.GA24530@lst.de> <53CCDFC3.5010802@gmail.com> <20140726162102.GA7126@lst.de> <1406533762.2003.13.camel@jarvis> <20140729122611.GA25980@lst.de>
In-Reply-To: <20140729122611.GA25980@lst.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 29.07.2014 14:26, Christoph Hellwig wrote:
> On Mon, Jul 28, 2014 at 11:49:22AM +0400, James Bottomley wrote:
>> That needs to be
>>
>> From: James Bottomley <JBottomley@Parallels.com>
>>
>> As well.  I do list handling on hansenpartnership.com to minimise
>> exchange wreckage on mailinglists, but I should acknowledge Parallels as
>> supporting the work I do.
> 
> Thanks, I've update the author, added a Cc to ћtable and pushed it out to
> the core-for-3.17 branch.
> 

Thanks guys!

Ref.
http://git.infradead.org/users/hch/scsi-queue.git/patch/884ffee?hp=16acf5d


poma


