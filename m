Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754333AbaKXRdM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 12:33:12 -0500
Received: from e36.co.us.ibm.com ([32.97.110.154]:36798 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753737AbaKXRdJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 12:33:09 -0500
Message-ID: <1416850383.4921.4.camel@dhcp-9-2-203-236.watson.ibm.com>
Subject: Re: [Keyrings] [PATCH 2/5] X.509: Support X.509 lookup by
 Issuer+Serial form AuthorityKeyIdentifier
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: David Howells <dhowells@redhat.com>
Cc: mmarek@suse.cz, keyrings@linux-nfs.org, d.kasatkin@samsung.com,
        rusty@rustcorp.com.au, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org, vgoyal@redhat.com
Date: Mon, 24 Nov 2014 12:33:03 -0500
In-Reply-To: <599.1416848314@warthog.procyon.org.uk>
References: <1416830320.25352.9.camel@dhcp-9-2-203-236.watson.ibm.com>
	 <20141120165351.5264.61930.stgit@warthog.procyon.org.uk>
	 <20141120165414.5264.95354.stgit@warthog.procyon.org.uk>
	 <1416787243.9616.4.camel@dhcp-9-2-203-236.watson.ibm.com>
	 <599.1416848314@warthog.procyon.org.uk>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14112417-0021-0000-0000-000006619DF5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-11-24 at 16:58 +0000, David Howells wrote: 
> Mimi Zohar <zohar@linux.vnet.ibm.com> wrote:
> 
> Mimi Zohar <zohar@linux.vnet.ibm.com> wrote:
> 
> > +        if (id) {
> > +		lookup = id->data;
> > +		len = id->len;
> > +	}
> >  	if (!lookup) {
> 
> The last line here can then just be replaced by an else-clause.

I would assume so, but the original code looked like "id->data" could
have been null.

Mimi

