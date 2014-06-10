Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754067AbaFJVpq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 17:45:46 -0400
Received: from mail-we0-f182.google.com ([74.125.82.182]:51978 "EHLO
	mail-we0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753249AbaFJVpo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 17:45:44 -0400
MIME-Version: 1.0
In-Reply-To: <20140610214038.GA13881@srcf.ucam.org>
References: <1402331614.7064.60.camel@dhcp-9-2-203-236.watson.ibm.com>
	<cover.1402387862.git.d.kasatkin@samsung.com>
	<20140610122008.GA31944@hansolo.jdub.homelinux.org>
	<CACE9dm9Ff6b3J=05QfcgBv-c_y=5qGNq1-ZSfo4smtj34i1e-A@mail.gmail.com>
	<20140610204021.GA8916@srcf.ucam.org>
	<CACE9dm9ma=XRZkoCiefva-dKL+LYw-s8QB4xUTkRUZH=5XM9ew@mail.gmail.com>
	<CACE9dm8zxVXx2zRcfDYUFjqvQYT4MbLevp5U13tfH9Hb6USSJw@mail.gmail.com>
	<20140610212516.GB10614@srcf.ucam.org>
	<CACE9dm95RiGxuG-XaGKd3KqBRkk+wyj3CBbMhaCTJQaiiaj9wQ@mail.gmail.com>
	<20140610214038.GA13881@srcf.ucam.org>
Date: Wed, 11 Jun 2014 00:45:43 +0300
Message-ID: <CACE9dm8jTWOVhf0uzcZmokmORFo=AzPO6po-X9xyqZZZKFK_Pw@mail.gmail.com>
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

On 11 June 2014 00:40, Matthew Garrett <mjg59@srcf.ucam.org> wrote:
> On Wed, Jun 11, 2014 at 12:34:28AM +0300, Dmitry Kasatkin wrote:
>
>> My statement is still valid. It is a hole...
>>
>> To prevent the hole it should be explained that one might follow
>> certain instructions
>> to take ownership of your PC. Generate your own keys and remove MS and
>> Vendor ones...
>
> The hole is that the system trusts keys that you don't trust. The
> appropriate thing to do is to remove that trust from the entire system,
> not just one layer of the system. If people gain the impression that
> they can simply pass a kernel parameter and avoid trusting the vendor
> keys, they'll be upset to discover that it's easily circumvented.
>
> --
> Matthew Garrett | mjg59@srcf.ucam.org

Yes. There is no reason to trust anything except your own...
Vendor keys, like Lenovo and OS keys like MS are not trusted.

They need to be completely replaced.

Probably we share the same view but talk about a bit different things..

- Dmitry
