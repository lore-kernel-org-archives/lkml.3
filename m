Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753737AbbA2BQb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 20:16:31 -0500
Received: from tundra.namei.org ([65.99.196.166]:38926 "EHLO namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753701AbbA2BQ2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 20:16:28 -0500
Date: Thu, 29 Jan 2015 10:45:51 +1100 (AEDT)
From: James Morris <jmorris@namei.org>
To: David Howells <dhowells@redhat.com>
cc: arnd@arndb.de, jkosina@suse.cz, keyrings@linux-nfs.org,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL] Keyrings, modsigning adjustments
In-Reply-To: <27884.1422019625@warthog.procyon.org.uk>
Message-ID: <alpine.LRH.2.11.1501291045371.2303@namei.org>
References: <27884.1422019625@warthog.procyon.org.uk>
User-Agent: Alpine 2.11 (LRH 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 23 Jan 2015, David Howells wrote:

> Hi James,
> 
> Could you pull these into security/next?  There are the following pieces:
> 
>  (1) Make /proc/keys unconditional as it's used by libkeyutils now.
> 
>  (2) Reduce the verbosity of the ASN.1 compiler and the X.509 certificate
>      collection during building.
> 
> Thanks,
> David
> ---
> The following changes since commit 961be7ef6963806cb978ccd6acf6bf84b0c63346:
> 
>   tpm/tpm_tis: Add missing ifdef CONFIG_ACPI for pnp_acpi_device (2015-01-22 13:37:33 +1100)
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/dhowells/linux-fs.git tags/keys-next-20150123
> 
> for you to fetch changes up to e994393acd65e729a574aaca466eab22b5b39cc6:
> 
>   X.509: silence asn1 compiler debug output (2015-01-23 12:10:39 +0000)
> 


Pulled, thanks.


-- 
James Morris
<jmorris@namei.org>

