Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754644AbaIKLnl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 07:43:41 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:47693 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753524AbaIKLnj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 07:43:39 -0400
Message-ID: <1410435813.5187.36.camel@dhcp-9-2-203-236.watson.ibm.com>
Subject: Re: [PATCH 2/6] KEYS: Reinstate EPERM for a key type name beginning
 with a '.'
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: David Howells <dhowells@redhat.com>
Cc: jmorris@namei.org, keyrings@linux-nfs.org, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org, Vivek Goyal <vgoyal@redhat.com>
Date: Thu, 11 Sep 2014 07:43:33 -0400
In-Reply-To: <1410392204.5187.14.camel@dhcp-9-2-203-236.watson.ibm.com>
References: <20140910212154.10752.23343.stgit@warthog.procyon.org.uk>
	 <20140910212206.10752.21818.stgit@warthog.procyon.org.uk>
	 <1410392204.5187.14.camel@dhcp-9-2-203-236.watson.ibm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14091111-8236-0000-0000-0000054F2055
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-09-10 at 19:36 -0400, Mimi Zohar wrote: 
> On Wed, 2014-09-10 at 22:22 +0100, David Howells wrote: 
> > Reinstate the generation of EPERM for a key type name beginning with a '.' in
> > a userspace call.  Types whose name begins with a '.' are internal only.

After re-reading your comment and looking at the different types,
testing for dot prefixed types now makes sense.  Both dot prefixed types
and keyring names are reserved for the kernel.

Mimi


