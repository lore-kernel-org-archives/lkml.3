Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755928Ab3AJUFj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2013 15:05:39 -0500
Received: from mx1.redhat.com ([209.132.183.28]:23422 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754495Ab3AJUFi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2013 15:05:38 -0500
Date: Thu, 10 Jan 2013 15:05:16 -0500
From: Josh Boyer <jwboyer@redhat.com>
To: David Howells <dhowells@redhat.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, pjones@redhat.com,
        mjg59@srcf.ucam.org, keescook@chromium.org, dmitry.kasatkin@intel.com,
        zohar@linux.vnet.ibm.com, keyrings@linux-nfs.org,
        linux-kernel@vger.kernel.org
Subject: Re: Pull "Load keys from signed PE binaries" branch into linux-next
Message-ID: <20130110200516.GI12363@hansolo.jdub.homelinux.org>
References: <24937.1357218319@warthog.procyon.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <24937.1357218319@warthog.procyon.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 03, 2013 at 01:05:19PM +0000, David Howells wrote:
> David Howells (23):
>       KEYS: Rename public key parameter name arrays
>       KEYS: Move the algorithm pointer array from x509 to public_key.c
>       KEYS: Store public key algo ID in public_key struct
>       KEYS: Split public_key_verify_signature() and make available
>       KEYS: Store public key algo ID in public_key_signature struct
>       X.509: struct x509_certificate needs struct tm declaring
>       X.509: Add bits needed for PKCS#7
>       X.509: Embed public_key_signature struct and create filler function
>       X.509: Handle certificates that lack an authorityKeyIdentifier field
>       X.509: Export certificate parse and free functions

The above patches are mostly cleanups and I can follow them fairly well.
The only real comment I had was the same one Kees already made about the
public_key_verify_signature_2 function.

Feel free to add a:

Reviewed-by: Josh Boyer <jwboyer@redhat.com>

josh
