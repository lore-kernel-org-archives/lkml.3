Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755305AbaFKDYJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 23:24:09 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:49700 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751634AbaFKDYH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 23:24:07 -0400
Date: Wed, 11 Jun 2014 04:23:55 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
Cc: Dmitry Kasatkin <dmitry.kasatkin@gmail.com>,
        Josh Boyer <jwboyer@redhat.com>, David Howells <dhowells@redhat.com>,
        Dmitry Kasatkin <d.kasatkin@samsung.com>,
        keyrings <keyrings@linux-nfs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-security-module <linux-security-module@vger.kernel.org>
Subject: Re: [PATCH 0/4] KEYS: validate key trust with owner and builtin keys
 only
Message-ID: <20140611032355.GA6470@srcf.ucam.org>
References: <CACE9dm9Ff6b3J=05QfcgBv-c_y=5qGNq1-ZSfo4smtj34i1e-A@mail.gmail.com>
 <20140610204021.GA8916@srcf.ucam.org>
 <CACE9dm9ma=XRZkoCiefva-dKL+LYw-s8QB4xUTkRUZH=5XM9ew@mail.gmail.com>
 <CACE9dm8zxVXx2zRcfDYUFjqvQYT4MbLevp5U13tfH9Hb6USSJw@mail.gmail.com>
 <20140610212516.GB10614@srcf.ucam.org>
 <CACE9dm95RiGxuG-XaGKd3KqBRkk+wyj3CBbMhaCTJQaiiaj9wQ@mail.gmail.com>
 <20140610214038.GA13881@srcf.ucam.org>
 <1402449893.612.14.camel@dhcp-9-2-203-236.watson.ibm.com>
 <20140611022222.GA2349@srcf.ucam.org>
 <1402456095.612.32.camel@dhcp-9-2-203-236.watson.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1402456095.612.32.camel@dhcp-9-2-203-236.watson.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 10, 2014 at 11:08:15PM -0400, Mimi Zohar wrote:
> On Wed, 2014-06-11 at 03:22 +0100, Matthew Garrett wrote: 
> > Providing a userspace mechanism for selectively dropping keys from the 
> > kernel seems like a good thing?
> 
> No, patch "KEYS: verify a certificate is signed by a 'trusted' key" adds
> signed public keys.

Yes. Wouldn't having a mechanism to allow userspace to drop keys that 
have otherwise been imported be a generally useful solution to the issue 
you have with that?

-- 
Matthew Garrett | mjg59@srcf.ucam.org
