Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753439AbaF3N6N (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 09:58:13 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:55683 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753113AbaF3N6K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 09:58:10 -0400
Message-ID: <1404136667.18987.5.camel@dhcp-9-2-203-236.watson.ibm.com>
Subject: Re: [PATCH v6 4/6] KEYS: validate certificate trust only with
 selected owner key
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: Dmitry Kasatkin <d.kasatkin@samsung.com>
Cc: David Howells <dhowells@redhat.com>, keyrings <keyrings@linux-nfs.org>,
        linux-security-module <linux-security-module@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Josh Boyer <jwboyer@redhat.com>, Matthew Garrett <mjg59@srcf.ucam.org>,
        Dmitry Kasatkin <dmitry.kasatkin@gmail.com>
Date: Mon, 30 Jun 2014 09:57:47 -0400
In-Reply-To: <53B16A64.4020903@samsung.com>
References: <1403620852-16476-5-git-send-email-zohar@linux.vnet.ibm.com>
	 <1403620852-16476-1-git-send-email-zohar@linux.vnet.ibm.com>
	 <7771.1403877346@warthog.procyon.org.uk>
	 <1403891079.9446.12.camel@dhcp-9-2-203-236.watson.ibm.com>
	 <53B16A64.4020903@samsung.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14063013-1542-0000-0000-000002F1B84B
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-06-30 at 16:47 +0300, Dmitry Kasatkin wrote: 
> On 27/06/14 20:44, Mimi Zohar wrote:
> > On Fri, 2014-06-27 at 14:55 +0100, David Howells wrote: 
> >> Mimi Zohar <zohar@linux.vnet.ibm.com> wrote:
> >>
> >>> This patch defines a new kernel parameter 'keys_ownerid' to identify
> >>> the owner's key which must be used for trust validation of certificates.
> >> "ca_keys" or "only_ca" instead, maybe?
> > Neither of these names reflect the concept of the machine owner or a
> > local key.  The initial patches named it 'owner_keyid'.  If kernel
> > parameters don't need to be prefixed with the subsystem, we could revert
> > the name change or call it localca_keyid.
> >
> > Mimi
> 
> I neither against any of proposals.
> 
> But considering that we use those keys to verify other keys, they become
> ca keys.
> So from that point of view I think 'ca_keys' reflects functionality
> quite ok.
> 
> localca_ prefix is may be not very relevant as builtin keys may
> comesfrom kernel vendor (RH, Ubuntu)
> and is not really local...

Ok.

> so let's decide on 'ca_keys'?

Ok.  This change isn't limited to just the kernel boot parameter name,
but needs to be reflected in the patch description and variable/function
names.

thanks,

Mimi

