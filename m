Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751662Ab3GXGGH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 02:06:07 -0400
Received: from mail-wg0-f42.google.com ([74.125.82.42]:59776 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751019Ab3GXGGG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 02:06:06 -0400
MIME-Version: 1.0
In-Reply-To: <20130723205139.GB10282@kroah.com>
References: <1374509230-3324-1-git-send-email-bergwolf@gmail.com> <20130723205139.GB10282@kroah.com>
From: Peng Tao <bergwolf@gmail.com>
Date: Wed, 24 Jul 2013 14:05:44 +0800
Message-ID: <CA+a=Yy5mDs7CHh76D9ATJ5fLsX41APVHAr4-=8tiCnGdBT6XTg@mail.gmail.com>
Subject: Re: [PATCH 00/48] staging/lustre: minor cleanup and Intel Lustre sync
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andreas Dilger <andreas.dilger@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 24, 2013 at 4:51 AM, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
> On Tue, Jul 23, 2013 at 12:06:21AM +0800, Peng Tao wrote:
>> Hi Greg,
>>
>> The first two of the patchset are minor cleanup of lustre code. And the
>> rest of it are patches ported from Intel Lustre tree. Please help to
>> queue them.
>
> I've applied most of these, see my comments on the ones I didn't.
>
> Feel free to fix those up and resend.
>
> Also please resync on my tree, as I tool some other lustre patches from
> different developers that might conflict with your future changes.
>
Thanks. I will fix up, rebase and resend.

Thanks,
Tao
