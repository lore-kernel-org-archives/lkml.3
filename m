Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754932Ab3AQSom (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2013 13:44:42 -0500
Received: from e9.ny.us.ibm.com ([32.97.182.139]:60925 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751152Ab3AQSoi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2013 13:44:38 -0500
Message-ID: <1358448263.2689.75.camel@falcor1>
Subject: Re: [PATCH 1/3] KEYS: Load *.x509 files into kernel keyring
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: David Howells <dhowells@redhat.com>
Cc: dmitry.kasatkin@intel.com, linux-kernel@vger.kernel.org,
        keyrings@linux-nfs.org, linux-security-module@vger.kernel.org,
        linux-crypto@vger.kernel.org
Date: Thu, 17 Jan 2013 13:44:23 -0500
In-Reply-To: <20130117180352.27885.79893.stgit@warthog.procyon.org.uk>
References: <20130117180352.27885.79893.stgit@warthog.procyon.org.uk>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13011718-7182-0000-0000-00000485B24D
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-01-17 at 18:03 +0000, David Howells wrote:
> Load all the files matching the pattern "*.x509" that are to be found in kernel
> base source dir and base build dir into the module signing keyring.

Do we really want certificates cluttering up the base source tree? Any
reason not to define an x509 directory?

> The "extra_certificates" file is then redundant.

Ok.

Mimi

