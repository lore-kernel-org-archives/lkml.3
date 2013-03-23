Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755807Ab3CWGgj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Mar 2013 02:36:39 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:61641 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755354Ab3CWGgh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Mar 2013 02:36:37 -0400
Message-ID: <514D4D6E.4000303@redhat.com>
Date: Sat, 23 Mar 2013 07:36:30 +0100
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130311 Thunderbird/17.0.4
MIME-Version: 1.0
To: gaowanlong@cn.fujitsu.com
CC: Asias He <asias@redhat.com>, linux-scsi@vger.kernel.org,
        kvm@vger.kernel.org, mst@redhat.com, linux-kernel@vger.kernel.org,
        JBottomley@parallels.com, virtualization@lists.linux-foundation.org
Subject: Re: [PATCH V6 5/5] virtio-scsi: reset virtqueue affinity when doing
 cpu hotplug
References: <1363762884-11000-1-git-send-email-gaowanlong@cn.fujitsu.com> <1363762884-11000-6-git-send-email-gaowanlong@cn.fujitsu.com> <20130320072425.GA23182@hj.localdomain> <51496BAF.2030202@cn.fujitsu.com>
In-Reply-To: <51496BAF.2030202@cn.fujitsu.com>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 20/03/2013 08:56, Wanlong Gao ha scritto:
>> This one does not apply on top of virtio-next + patch 1-4 in this series.
> 
> I'm very sorry.
> 
> This fault is because I modified the 4/5 from 
> "/* if the affinity hint is set for virtqueues */"
> to
> "/* If the affinity hint is set for virtqueues */"
> by hand.
> 
> You can also change "If" to "if" in 5/5 to apply this patch without 3-way merge.

Can you respin?

So we can ask James for his Acked-by and get this merged in the next window.

Paolo
