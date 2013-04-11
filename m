Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761615Ab3DKSm7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 14:42:59 -0400
Received: from mail-wg0-f50.google.com ([74.125.82.50]:43719 "EHLO
	mail-wg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756630Ab3DKSm4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 14:42:56 -0400
MIME-Version: 1.0
In-Reply-To: <20130411145550.GD21260@redhat.com>
References: <CALLzPKavbsZgHoJrk5iQ0F1fO21SaeEHmCVCh1G1UKCKB3WZZQ@mail.gmail.com>
	<20130405135000.GB6299@redhat.com>
	<1365450229.3847.56.camel@falcor1.watson.ibm.com>
	<20130408200904.GI28292@redhat.com>
	<CA+5PVA43U_kDSV7p0zhQwmK9pwbVb8qAUePU8svQvoPbDA9iCQ@mail.gmail.com>
	<20130409143852.GH6320@redhat.com>
	<1365563230.3074.107.camel@falcor1.watson.ibm.com>
	<20130410194209.GF6602@redhat.com>
	<1365627922.2452.32.camel@falcor1.watson.ibm.com>
	<CACE9dm-GZpjco8u6jNxLQpYA8LYSeoVjsyyRXVwxXHzjO-LvGw@mail.gmail.com>
	<20130411145550.GD21260@redhat.com>
Date: Thu, 11 Apr 2013 21:42:54 +0300
Message-ID: <CACE9dm-+CY+aLcsrR8CF2TsL26S1wZbYKYS4ropW3ie6tmMZ+Q@mail.gmail.com>
Subject: Re: [RFC 2/2] initramfs with digital signature protection
From: Dmitry Kasatkin <dmitry.kasatkin@gmail.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Mimi Zohar <zohar@linux.vnet.ibm.com>, Josh Boyer <jwboyer@gmail.com>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 11, 2013 at 5:55 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> On Thu, Apr 11, 2013 at 11:06:55AM +0300, Dmitry Kasatkin wrote:
>> Hello,
>>
>> I respond to the original question of this thread.
>> signed initramfs allows not only to add keys to the keyrings but perform
>> other initialization,
>> which requires user-space.
>> Keys can be embedded into the kernel. This is fine.
>
> What other initialization user space need to do where we can't trust
> root (even in secureboot mode).
>
> IOW, if keys can be embedded in kernel (or read from UEFI db and MOK db),
> what other operation requires initramfs to be signed. It could very well
> be unsigned initramfs like today.
>

It looks like you do not hear me.
I said that any user space initialization can be done from signed user space.
For example IMA policy can be initialized.

I see that you see your particular case and in that case you do not
require that.
That is fine. That is your case....

 - Dmitry

> Thanks
> Vivek
