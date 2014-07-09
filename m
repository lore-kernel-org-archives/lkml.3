Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756010AbaGIQD7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 12:03:59 -0400
Received: from mail.skyhub.de ([78.46.96.112]:54035 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755893AbaGIQD5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 12:03:57 -0400
Date: Wed, 9 Jul 2014 18:03:49 +0200
From: Borislav Petkov <bp@alien8.de>
To: David Howells <dhowells@redhat.com>, Vivek Goyal <vgoyal@redhat.com>
Cc: keyrings@linux-nfs.org, linux-security-module@vger.kernel.org,
        kexec@lists.infradead.org, linux-kernel@vger.kernel.org,
        x86-ml <x86@kernel.org>
Subject: Re: [PATCH 00/17] KEYS: PKCS#7 and PE file signature checking for
 kexec
Message-ID: <20140709160349.GA5292@pd.tnic>
References: <20140709151525.23074.32315.stgit@warthog.procyon.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20140709151525.23074.32315.stgit@warthog.procyon.org.uk>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi David,

On Wed, Jul 09, 2014 at 04:15:25PM +0100, David Howells wrote:
> David Howells (16):
>       X.509: Add bits needed for PKCS#7
>       X.509: Export certificate parse and free functions
>       PKCS#7: Implement a parser [RFC 2315]
>       PKCS#7: Digest the data in a signed-data message
>       PKCS#7: Find the right key in the PKCS#7 key list and verify the signature
>       PKCS#7: Verify internal certificate chain
>       PKCS#7: Find intersection between PKCS#7 message and known, trusted keys
>       PKCS#7: Provide a key type for testing PKCS#7
>       KEYS: X.509: Fix a spelling mistake
>       Provide PE binary definitions
>       pefile: Parse a PE binary to find a key and a signature contained therein
>       pefile: Strip the wrapper off of the cert data block
>       pefile: Parse the presumed PKCS#7 content of the certificate blob
>       pefile: Parse the "Microsoft individual code signing" data blob
>       pefile: Digest the PE binary and compare to the PKCS#7 data
>       pefile: Validate PKCS#7 trust chain
> 
> Vivek Goyal (1):
>       pefile: Handle pesign using the wrong OID

let me see if I get this straight:

this current submission is supposed to replace

http://lkml.kernel.org/r/20140708131504.28621.61165.stgit@warthog.procyon.org.uk

and Vivek's one:

http://lkml.kernel.org/r/1404421641-12691-1-git-send-email-vgoyal@redhat.com

(which added those parsers to arch/x86/kernel/ - not a good place anyway.)

?

The kexec bits with the sig verif will come ontop, it seems. What's the
story guys?

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
