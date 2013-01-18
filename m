Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754932Ab3ARPRj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2013 10:17:39 -0500
Received: from e38.co.us.ibm.com ([32.97.110.159]:36431 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751417Ab3ARPRh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2013 10:17:37 -0500
Message-ID: <1358522198.26115.6.camel@falcor1.watson.ibm.com>
Subject: Re: [RFC 0/1] ima/evm: signature verification support using
 asymmetric keys
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: David Howells <dhowells@redhat.com>
Cc: Dmitry Kasatkin <dmitry.kasatkin@intel.com>, jmorris@namei.org,
        linux-security-module@vger.kernel.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Fri, 18 Jan 2013 10:16:38 -0500
In-Reply-To: <27882.1358445829@warthog.procyon.org.uk>
References: <1358365541.4593.190.camel@falcor1>
	 <cover.1358246017.git.dmitry.kasatkin@intel.com>
	 <27882.1358445829@warthog.procyon.org.uk>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13011815-5518-0000-0000-00000AD72F25
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-01-17 at 18:03 +0000, David Howells wrote:

> I would also like to have a look at altering your trusted key type[*] to be a
> subtype of asymmetric keys so that the asymmetric key type can cover keys from
> more sources:
> 
> 	- Compiled-in keys.
> 	- Keys from UEFI db.
> 	- Keys from TPM (ie. the trusted key stuff).
> 	- Keys loaded by the administrator _if_ they are validated by a key the
> 	  kernel already has.
> 	
> [*] I believe that that's your asymmetric key type and that your encrypted key
>     type is your symmetric key type.

Both trusted and encrypted keys are random number symmetric keys.
Trusted keys are random number symmetric keys, generated and RSA-sealed
by the TPM.

Mimi


