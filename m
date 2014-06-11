Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755079AbaFKMae (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 08:30:34 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:44905 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753971AbaFKMaa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 08:30:30 -0400
Message-ID: <1402489820.612.58.camel@dhcp-9-2-203-236.watson.ibm.com>
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
Date: Wed, 11 Jun 2014 08:30:20 -0400
In-Reply-To: <20140611032355.GA6470@srcf.ucam.org>
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
	 <20140611032355.GA6470@srcf.ucam.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14061112-3532-0000-0000-00000267103E
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-06-11 at 04:23 +0100, Matthew Garrett wrote: 
> Yes. Wouldn't having a mechanism to allow userspace to drop keys that 
> have otherwise been imported be a generally useful solution to the issue 
> you have with that?

There are issues removing a key from both the local system(eg. cache,
running apps) and the attestation server (eg. ima-sig template
verification) perspectives.  We would need to address these concerns
before supporting key removal.

Mimi

