Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755724Ab3JNBsZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Oct 2013 21:48:25 -0400
Received: from mail-bk0-f51.google.com ([209.85.214.51]:39457 "EHLO
	mail-bk0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755583Ab3JNBsX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Oct 2013 21:48:23 -0400
MIME-Version: 1.0
In-Reply-To: <20131013195735.GD18075@htj.dyndns.org>
References: <1380366816-16221-1-git-send-email-yxlraid@gmail.com>
	<20130928114950.GA2620@htj.dyndns.org>
	<CAP0P+NUvaLfXkOUGm8NX19AHvTHmU=Ya0NdFvyJc2gFjN-Cy0A@mail.gmail.com>
	<20130928131059.GA3945@htj.dyndns.org>
	<CAP0P+NXD7pdXQwBUZJdUwyCc=o_5iTzmKJ6FdN6LrqcgX3yK2A@mail.gmail.com>
	<20131013195735.GD18075@htj.dyndns.org>
Date: Mon, 14 Oct 2013 09:48:21 +0800
Message-ID: <CAP0P+NWQCyk+DpNASn7AO=7zQoG7K1WvcSaKa2+dHyJcS1EvvA@mail.gmail.com>
Subject: Re: [PATCH 1/1] AHCI: disabled FBS prior to issuing software reset
From: xiangliang yu <yxlraid@gmail.com>
To: Tejun Heo <tj@kernel.org>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

> On Sat, Oct 12, 2013 at 02:56:34PM +0800, xiangliang yu wrote:
>> > So it can't find the disk if FBS stays enabled?  Can you please attach
>> > the boot log before & after?
>>
>> Below is boot log:
>
> And it works after the patch, right?  Can you please update the patch
> description so that it includes what was failing before and how it was
> tested?
>
Yes. I'll update the patch later.

Thanks.
