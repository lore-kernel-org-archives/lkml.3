Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754117AbaFKBZD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 21:25:03 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:54785 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753064AbaFKBY7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 21:24:59 -0400
Message-ID: <1402449893.612.14.camel@dhcp-9-2-203-236.watson.ibm.com>
Subject: Re: [PATCH 0/4] KEYS: validate key trust with owner and builtin
 keys only
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Dmitry Kasatkin <dmitry.kasatkin@gmail.com>,
        Josh Boyer <jwboyer@redhat.com>, David Howells <dhowells@redhat.com>,
        Dmitry Kasatkin <d.kasatkin@samsung.com>,
        keyrings <keyrings@linux-nfs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-security-module <linux-security-module@vger.kernel.org>
Date: Tue, 10 Jun 2014 21:24:53 -0400
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
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14061101-6688-0000-0000-0000027BA261
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-06-10 at 22:40 +0100, Matthew Garrett wrote: 
> On Wed, Jun 11, 2014 at 12:34:28AM +0300, Dmitry Kasatkin wrote:
> 
> > My statement is still valid. It is a hole...
> > 
> > To prevent the hole it should be explained that one might follow
> > certain instructions
> > to take ownership of your PC. Generate your own keys and remove MS and
> > Vendor ones...
> 
> The hole is that the system trusts keys that you don't trust. The 
> appropriate thing to do is to remove that trust from the entire system, 
> not just one layer of the system. If people gain the impression that 
> they can simply pass a kernel parameter and avoid trusting the vendor 
> keys, they'll be upset to discover that it's easily circumvented.

Assuming I remove all the keys I don't trust, there are still keys that
are trusted while booting, but are not necessary afterwards.  We should
be able to limit the scope of where and when keys are trusted.

Mimi

