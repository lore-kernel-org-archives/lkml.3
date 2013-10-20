Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751450Ab3JTLlf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Oct 2013 07:41:35 -0400
Received: from mail-we0-f175.google.com ([74.125.82.175]:34576 "EHLO
	mail-we0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751262Ab3JTLle (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Oct 2013 07:41:34 -0400
MIME-Version: 1.0
In-Reply-To: <20131020102203.GB77546@vega.codepro.be>
References: <CABjrhvqTHkuEyQ=-xaud5Y0i3YqYcdBsm2eWrR-44V=OESWypg@mail.gmail.com>
	<20131020102203.GB77546@vega.codepro.be>
Date: Sun, 20 Oct 2013 19:41:32 +0800
Message-ID: <CABjrhvoXWL7KQ8=pE8TqMGPuayQEcQ72qYP1Cf+gOnb3ZovRNw@mail.gmail.com>
Subject: Re: [RFC] Rollback FS
From: jiaweiwei <jiaweiwei.xiyou@gmail.com>
To: Kristof Provost <kristof@sigsegv.be>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Harry Wei <harryxiyou@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 20, 2013 at 6:22 PM, Kristof Provost <kristof@sigsegv.be> wrote:
> On 2013-10-20 15:06:33 (+0800), jiaweiwei <jiaweiwei.xiyou@gmail.com> wrote:
>> We could implement a File System to record all the operations which
>> send to VFS. Then when you think you have done a mistake command, you
>> could rollback from this File System.
>>
>> This is just a RFC, I would give detail implementations. Would anyone
>> please give me some suggestions? Thanks very much.
>
> I think it needs to be fleshed out a lot more.

Yeah, I think so.

>
> For example, how would you tell it to roll back without a functional
> libc? How does it differ from the snapshot feature in btrfs?

I have not got detail implementation. I would give it and then we
could talk with it.
Thanks.


-- 
 do kernel
