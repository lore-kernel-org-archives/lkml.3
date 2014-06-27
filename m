Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752275AbaF0RuU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2014 13:50:20 -0400
Received: from e38.co.us.ibm.com ([32.97.110.159]:40781 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751874AbaF0RuR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2014 13:50:17 -0400
Message-ID: <1403891411.9446.17.camel@dhcp-9-2-203-236.watson.ibm.com>
Subject: Re: [PATCH v6 5/6] KEYS: validate certificate trust only with
 builtin keys
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: David Howells <dhowells@redhat.com>
Cc: Dmitry Kasatkin <d.kasatkin@samsung.com>,
        keyrings <keyrings@linux-nfs.org>,
        linux-security-module <linux-security-module@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Josh Boyer <jwboyer@redhat.com>, Matthew Garrett <mjg59@srcf.ucam.org>,
        Dmitry Kasatkin <dmitry.kasatkin@gmail.com>
Date: Fri, 27 Jun 2014 13:50:11 -0400
In-Reply-To: <7729.1403877251@warthog.procyon.org.uk>
References: <1403620852-16476-6-git-send-email-zohar@linux.vnet.ibm.com>
	 <1403620852-16476-1-git-send-email-zohar@linux.vnet.ibm.com>
	 <7729.1403877251@warthog.procyon.org.uk>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14062717-1344-0000-0000-0000027861C4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-06-27 at 14:54 +0100, David Howells wrote: 
> Mimi Zohar <zohar@linux.vnet.ibm.com> wrote:
> 
> > +static bool builtin_keys;
> 
> Could we call this something like "use_builtin_keys_only"?
> 
> Looks okay otherwise.

The current patches support either a single key or the builtin keys, not
both.  In case this behavior changes, I'd prefer using
'use_builtin_keys'.

thanks,

Mimi

