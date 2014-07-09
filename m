Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756570AbaGIV3P (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 17:29:15 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:42006 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751010AbaGIV3N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 17:29:13 -0400
Message-ID: <1404941347.14643.57.camel@dhcp-9-2-203-236.watson.ibm.com>
Subject: Re: [PATCH v6 0/6] ima: extending secure boot certificate chain of
 trust
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: David Howells <dhowells@redhat.com>
Cc: keyrings <keyrings@linux-nfs.org>,
        linux-security-module <linux-security-module@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Josh Boyer <jwboyer@redhat.com>, Matthew Garrett <mjg59@srcf.ucam.org>,
        Dmitry Kasatkin <dmitry.kasatkin@gmail.com>
Date: Wed, 09 Jul 2014 17:29:07 -0400
In-Reply-To: <8975.1404932208@warthog.procyon.org.uk>
References: <1404924054.14643.36.camel@dhcp-9-2-203-236.watson.ibm.com>
	 <1403620852-16476-1-git-send-email-zohar@linux.vnet.ibm.com>
	 <24144.1404919879@warthog.procyon.org.uk>
	 <8975.1404932208@warthog.procyon.org.uk>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14070921-9332-0000-0000-000001552CC0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-07-09 at 19:56 +0100, David Howells wrote: 
> Mimi Zohar <zohar@linux.vnet.ibm.com> wrote:
> 
> > Yes, that's fine.  My concern, however, is that the trusted keyring
> > patches are independent of the other patches being upstreamed and should
> > be upstreamed regardless of the other patches.
> 
> There is overlap in the X.509 certificate request function that you took from
> my pkcs#7 patches.

Right, x509_request_asymmetric_key() is the same as
pkcs7_request_asymmetric_key().

Mimi

