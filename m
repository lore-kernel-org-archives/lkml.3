Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933885AbaGPNPy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 09:15:54 -0400
Received: from e37.co.us.ibm.com ([32.97.110.158]:54537 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932748AbaGPNPv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 09:15:51 -0400
Message-ID: <1405516544.1466.50.camel@dhcp-9-2-203-236.watson.ibm.com>
Subject: Re: [PATCH v6 0/6] ima: extending secure boot certificate chain of
 trust
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: David Howells <dhowells@redhat.com>
Cc: Dmitry Kasatkin <d.kasatkin@samsung.com>,
        keyrings <keyrings@linux-nfs.org>,
        linux-security-module <linux-security-module@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Josh Boyer <jwboyer@redhat.com>, Matthew Garrett <mjg59@srcf.ucam.org>,
        Dmitry Kasatkin <dmitry.kasatkin@gmail.com>
Date: Wed, 16 Jul 2014 09:15:44 -0400
In-Reply-To: <488.1405285619@warthog.procyon.org.uk>
References: <53BEA780.5050602@samsung.com>
	 <1404924054.14643.36.camel@dhcp-9-2-203-236.watson.ibm.com>
	 <1403620852-16476-1-git-send-email-zohar@linux.vnet.ibm.com>
	 <24144.1404919879@warthog.procyon.org.uk>
	 <8975.1404932208@warthog.procyon.org.uk>
	 <1404941347.14643.57.camel@dhcp-9-2-203-236.watson.ibm.com>
	 <488.1405285619@warthog.procyon.org.uk>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14071613-7164-0000-0000-0000032BE773
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2014-07-13 at 22:06 +0100, David Howells wrote: 
> Dmitry Kasatkin <d.kasatkin@samsung.com> wrote:
> 
> > If patches from integrity/next-trusted-keys goes via your tree, then I
> > suggest that you re-base your patches on the top of our
> > patchset, because it is unclear how long review of PE, PKCS7 patches
> > will take and if they will be pulled...
> 
> I'd rather not do that since other things are now depending on my patches.
> 
> What's probably better is just to clean up the duplication later.  That way,
> there need be no dependency between the two sets.

We're already at -rc5.  Any pull requests for the next open window need
to submitted soon.  If/when are you planning on sending James the pull
request?  (I'm kind of waiting for the KEY patches to make it in, before
sending the linux-integrity pull request.)

thanks,

Mimi

