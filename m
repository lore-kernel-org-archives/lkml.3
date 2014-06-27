Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753226AbaF0OQm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2014 10:16:42 -0400
Received: from mx1.redhat.com ([209.132.183.28]:42877 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753173AbaF0OQk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2014 10:16:40 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20140611032355.GA6470@srcf.ucam.org>
References: <20140611032355.GA6470@srcf.ucam.org> <CACE9dm9Ff6b3J=05QfcgBv-c_y=5qGNq1-ZSfo4smtj34i1e-A@mail.gmail.com> <20140610204021.GA8916@srcf.ucam.org> <CACE9dm9ma=XRZkoCiefva-dKL+LYw-s8QB4xUTkRUZH=5XM9ew@mail.gmail.com> <CACE9dm8zxVXx2zRcfDYUFjqvQYT4MbLevp5U13tfH9Hb6USSJw@mail.gmail.com> <20140610212516.GB10614@srcf.ucam.org> <CACE9dm95RiGxuG-XaGKd3KqBRkk+wyj3CBbMhaCTJQaiiaj9wQ@mail.gmail.com> <20140610214038.GA13881@srcf.ucam.org> <1402449893.612.14.camel@dhcp-9-2-203-236.watson.ibm.com> <20140611022222.GA2349@srcf.ucam.org> <1402456095.612.32.camel@dhcp-9-2-203-236.watson.ibm.com>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: dhowells@redhat.com, Mimi Zohar <zohar@linux.vnet.ibm.com>,
        Dmitry Kasatkin <dmitry.kasatkin@gmail.com>,
        Josh Boyer <jwboyer@redhat.com>,
        Dmitry Kasatkin <d.kasatkin@samsung.com>,
        keyrings <keyrings@linux-nfs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-security-module <linux-security-module@vger.kernel.org>
Subject: Re: [PATCH 0/4] KEYS: validate key trust with owner and builtin keys only
Date: Fri, 27 Jun 2014 15:16:23 +0100
Message-ID: <8039.1403878583@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Matthew Garrett <mjg59@srcf.ucam.org> wrote:

> Yes. Wouldn't having a mechanism to allow userspace to drop keys that 
> have otherwise been imported be a generally useful solution to the issue 
> you have with that?

"keyctl invalidate" could be a way to drop keys.

David
