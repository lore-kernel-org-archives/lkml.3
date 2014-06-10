Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754285AbaFJVkx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 17:40:53 -0400
Received: from mail-wg0-f46.google.com ([74.125.82.46]:38727 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753874AbaFJVkt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 17:40:49 -0400
MIME-Version: 1.0
In-Reply-To: <CACE9dm95RiGxuG-XaGKd3KqBRkk+wyj3CBbMhaCTJQaiiaj9wQ@mail.gmail.com>
References: <1402331614.7064.60.camel@dhcp-9-2-203-236.watson.ibm.com>
	<cover.1402387862.git.d.kasatkin@samsung.com>
	<20140610122008.GA31944@hansolo.jdub.homelinux.org>
	<CACE9dm9Ff6b3J=05QfcgBv-c_y=5qGNq1-ZSfo4smtj34i1e-A@mail.gmail.com>
	<20140610204021.GA8916@srcf.ucam.org>
	<CACE9dm9ma=XRZkoCiefva-dKL+LYw-s8QB4xUTkRUZH=5XM9ew@mail.gmail.com>
	<CACE9dm8zxVXx2zRcfDYUFjqvQYT4MbLevp5U13tfH9Hb6USSJw@mail.gmail.com>
	<20140610212516.GB10614@srcf.ucam.org>
	<CACE9dm95RiGxuG-XaGKd3KqBRkk+wyj3CBbMhaCTJQaiiaj9wQ@mail.gmail.com>
Date: Wed, 11 Jun 2014 00:40:48 +0300
Message-ID: <CACE9dm8mfFvzS7qSHZFsodoiTHzba3AJF4kr2SrY20cNUiXrfQ@mail.gmail.com>
Subject: Re: [PATCH 0/4] KEYS: validate key trust with owner and builtin keys only
From: Dmitry Kasatkin <dmitry.kasatkin@gmail.com>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Josh Boyer <jwboyer@redhat.com>, David Howells <dhowells@redhat.com>,
        Mimi Zohar <zohar@linux.vnet.ibm.com>,
        Dmitry Kasatkin <d.kasatkin@samsung.com>,
        keyrings <keyrings@linux-nfs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-security-module <linux-security-module@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11 June 2014 00:34, Dmitry Kasatkin <dmitry.kasatkin@gmail.com> wrote:
> On 11 June 2014 00:25, Matthew Garrett <mjg59@srcf.ucam.org> wrote:
>> On Wed, Jun 11, 2014 at 12:17:53AM +0300, Dmitry Kasatkin wrote:
>>
>>> It is probably just a paranoia...
>>> Kconfig MODULE_SIG_UEFI should tell about threat of loading kernel
>>> modules from NSA or Lenovo signed by MS or Lenovo keys..
>>>
>>> This hole is opened without warning...
>>
>> It's not typically a hole. If an attacker has root they can just replace
>> your bootloader with one signed by a trusted key and then have that
>> modify the kernel before booting it.
>>
>> If you're using a TPM then you can mitigate this, but if you have a TPM
>> then you're already performing some extra steps during the boot process.
>> Just add a sysfs knob that lets you drop the db keys and incorporate
>> that into the TPM management code.
>>
>> --
>> Matthew Garrett | mjg59@srcf.ucam.org
>
> I was expecting this boot loader answer.
>
> Indeed, if system is design to prevent online modification of bootloader then
> kernel parameters are protected as well...
>
> My statement is still valid. It is a hole...
>
> To prevent the hole it should be explained that one might follow
> certain instructions
> to take ownership of your PC. Generate your own keys and remove MS and
> Vendor ones...
>
> It is paranoia? May be not.
>
> - Dmitry

I must admit that bootloader replacement is not related to kernel...

It is just paranoia...

- dmitry
