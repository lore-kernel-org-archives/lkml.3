Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752648AbaETIFD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 04:05:03 -0400
Received: from mail-ob0-f182.google.com ([209.85.214.182]:61530 "EHLO
	mail-ob0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752561AbaETIEm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 04:04:42 -0400
MIME-Version: 1.0
In-Reply-To: <20140520070605.GA7961@kroah.com>
References: <20140520170031.1d27c26a@canb.auug.org.au> <20140520070605.GA7961@kroah.com>
From: Sumit Semwal <sumit.semwal@linaro.org>
Date: Tue, 20 May 2014 13:34:19 +0530
Message-ID: <CAO_48GGLfTKh0nFfCAMi_bqi4u=_ycrwYS_NfqiAfd+g5ah9_g@mail.gmail.com>
Subject: Re: linux-next: manual merge of the dma-buf tree with the staging tree
To: Greg KH <greg@kroah.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        Maarten Lankhorst <maarten.lankhorst@canonical.com>,
        Seunghun Lee <waydi1@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 20 May 2014 12:36, Greg KH <greg@kroah.com> wrote:
> On Tue, May 20, 2014 at 05:00:31PM +1000, Stephen Rothwell wrote:
>> Hi Sumit,
>>
>> Today's linux-next merge of the dma-buf tree got a conflict in
>> drivers/staging/android/sync.c between commit 10f62861b4a2 ("staging:
>> android: fix missing a blank line after declarations") from the staging
>> tree and commit 85958aff6184 ("android: convert sync to fence api, v5")
>> from the dma-buf tree.
>>
>> I fixed it up (I just used the dma-buf tree version of conflicting
>> sections) and can carry the fix as necessary (no action is required).
>
> Sounds good, thanks.
>
> greg k-h

Sure Stephen,

Sounds good! Thanks.

Sumit
