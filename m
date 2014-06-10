Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932183AbaFJVAn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 17:00:43 -0400
Received: from mail-wi0-f175.google.com ([209.85.212.175]:35324 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754932AbaFJVAl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 17:00:41 -0400
MIME-Version: 1.0
In-Reply-To: <20140610204021.GA8916@srcf.ucam.org>
References: <1402331614.7064.60.camel@dhcp-9-2-203-236.watson.ibm.com>
	<cover.1402387862.git.d.kasatkin@samsung.com>
	<20140610122008.GA31944@hansolo.jdub.homelinux.org>
	<CACE9dm9Ff6b3J=05QfcgBv-c_y=5qGNq1-ZSfo4smtj34i1e-A@mail.gmail.com>
	<20140610204021.GA8916@srcf.ucam.org>
Date: Wed, 11 Jun 2014 00:00:39 +0300
Message-ID: <CACE9dm9ma=XRZkoCiefva-dKL+LYw-s8QB4xUTkRUZH=5XM9ew@mail.gmail.com>
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

On 10 June 2014 23:40, Matthew Garrett <mjg59@srcf.ucam.org> wrote:
> On Tue, Jun 10, 2014 at 11:34:17PM +0300, Dmitry Kasatkin wrote:
>
>> Preventing loading keys from uefi except dbx by default actually improves
>> security. Adding kernel parameter to read db we make system more
>> vulnerable.
>
> It only adds security if you're performing a measured boot and remote
> attestation. Otherwise you implicitly trust that key anyway. In almost
> all cases refusing to trust db gives you a false sense of security
> without any real improvement. I don't think it's obvious it should be
> the default.
>
> --
> Matthew Garrett | mjg59@srcf.ucam.org

May be you are right... "in almost all cases"...

It does not mater if one trust DB or not... It's all about
distro/system configuration...

Normal user even will not know what is default behavior and what
kernel parameter disables or enables...
And distro will have it by default or will use kernel parameter... It
does not change anything...

I am just discussing kernel configuration...
Without kind of looking to it  I cannot be sure if UEFI keys will
appear on system keyring or not.
Now I have to be aware how kernel is compiled... If it is compiled
with CONFIG_KEYS_UEFI or so
I need to remember may be to supply addition kernel parameters to
limit key UEFI usage...

It is may be not a big deal...

-- 
Thanks,
Dmitry
