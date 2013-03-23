Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751841Ab3CWOAw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Mar 2013 10:00:52 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:59055 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751324Ab3CWOAQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Mar 2013 10:00:16 -0400
X-IronPort-AV: E=Sophos;i="4.87,337,1363104000"; 
   d="scan'208";a="6929138"
Message-ID: <514D8F18.40905@cn.fujitsu.com>
Date: Sat, 23 Mar 2013 19:16:40 +0800
From: Wanlong Gao <gaowanlong@cn.fujitsu.com>
Reply-To: gaowanlong@cn.fujitsu.com
Organization: Fujitsu
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130311 Thunderbird/17.0.4
MIME-Version: 1.0
To: Paolo Bonzini <pbonzini@redhat.com>
CC: Asias He <asias@redhat.com>, linux-scsi@vger.kernel.org,
        kvm@vger.kernel.org, mst@redhat.com, linux-kernel@vger.kernel.org,
        JBottomley@parallels.com, virtualization@lists.linux-foundation.org,
        Wanlong Gao <gaowanlong@cn.fujitsu.com>
Subject: Re: [PATCH V6 5/5] virtio-scsi: reset virtqueue affinity when doing
 cpu hotplug
References: <1363762884-11000-1-git-send-email-gaowanlong@cn.fujitsu.com> <1363762884-11000-6-git-send-email-gaowanlong@cn.fujitsu.com> <20130320072425.GA23182@hj.localdomain> <51496BAF.2030202@cn.fujitsu.com> <514D4D6E.4000303@redhat.com>
In-Reply-To: <514D4D6E.4000303@redhat.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/03/23 19:14:43,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/03/23 19:14:58,
	Serialize complete at 2013/03/23 19:14:58
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/23/2013 02:36 PM, Paolo Bonzini wrote:
> Il 20/03/2013 08:56, Wanlong Gao ha scritto:
>>> This one does not apply on top of virtio-next + patch 1-4 in this series.
>>
>> I'm very sorry.
>>
>> This fault is because I modified the 4/5 from 
>> "/* if the affinity hint is set for virtqueues */"
>> to
>> "/* If the affinity hint is set for virtqueues */"
>> by hand.
>>
>> You can also change "If" to "if" in 5/5 to apply this patch without 3-way merge.
> 
> Can you respin?
> 
> So we can ask James for his Acked-by and get this merged in the next window.

Sure.

Thanks,
Wanlong Gao

> 
> Paolo
> 

