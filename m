Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751461Ab3LKSsk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 13:48:40 -0500
Received: from mail-ie0-f180.google.com ([209.85.223.180]:42384 "EHLO
	mail-ie0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751157Ab3LKSsj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 13:48:39 -0500
MIME-Version: 1.0
In-Reply-To: <CAE9FiQWcUqK11PSD-fCnD_G8HzvTh08N8h5tvQe2Z_YdZa7POQ@mail.gmail.com>
References: <1385429290-25397-1-git-send-email-yinghai@kernel.org>
 <1385429290-25397-11-git-send-email-yinghai@kernel.org> <CAErSpo4Sa6hpv45E9fQB_LsSrTt_mFzxbJvRocuCo9HXcAYfow@mail.gmail.com>
 <CAE9FiQWcUqK11PSD-fCnD_G8HzvTh08N8h5tvQe2Z_YdZa7POQ@mail.gmail.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Wed, 11 Dec 2013 11:48:18 -0700
Message-ID: <CAErSpo4dV_BWj1PFxzmeweg++iA7V8z56P5ZO=vArK4kB_ve4Q@mail.gmail.com>
Subject: Re: [PATCH v2 10/10] intel-gtt: Read 64bit for gmar_bus_addr
To: Yinghai Lu <yinghai@kernel.org>
Cc: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Gu Zheng <guz.fnst@cn.fujitsu.com>, Guo Chao <yan@linux.vnet.ibm.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        David Airlie <airlied@linux.ie>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 26, 2013 at 12:35 PM, Yinghai Lu <yinghai@kernel.org> wrote:
> On Mon, Nov 25, 2013 at 7:46 PM, Bjorn Helgaas <bhelgaas@google.com> wrote:
>> On Mon, Nov 25, 2013 at 6:28 PM, Yinghai Lu <yinghai@kernel.org> wrote:
>>> That bar could be 64bit pref mem and above 4G.
>>>
>>> -v2: refresh to 3.13-rc1
>>>
>>> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
>>> Cc: David Airlie <airlied@linux.ie>
>>> Reviewed-by: Daniel Vetter <daniel.vetter@ffwll.ch>
>>
>> This looks OK to me.  Does it depend on any previous patches in this
>> series?  If not, I think Dave should pick it up.
>
> No.
>
> could be exposed after 5-9 get applied.

Doesn't that mean that this series should be reordered so this patch
is *before* patches 5-9 to avoid bisection breakage?  I know you've
split up and reposted parts of the series, but the question still
applies.

Bjorn
