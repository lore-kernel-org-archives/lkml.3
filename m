Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755785AbaFYJkO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 05:40:14 -0400
Received: from cpsmtpb-ews01.kpnxchange.com ([213.75.39.4]:51578 "EHLO
	cpsmtpb-ews01.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753893AbaFYJkJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 05:40:09 -0400
Message-ID: <1403689208.1960.40.camel@x220>
Subject: Re: [PATCH] [TRIVIAL] Documentation: Fix typo 'CONFIG_AFS'
From: Paul Bolle <pebolle@tiscali.nl>
To: David Howells <dhowells@redhat.com>
Cc: Jiri Kosina <trivial@kernel.org>, linux-afs@lists.infradead.org,
        linux-kernel@vger.kernel.org
Date: Wed, 25 Jun 2014 11:40:08 +0200
In-Reply-To: <6075.1403687355@warthog.procyon.org.uk>
References: <1403683888.1960.35.camel@x220>
	 <6075.1403687355@warthog.procyon.org.uk>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-2.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 25 Jun 2014 09:40:08.0450 (UTC) FILETIME=[73B0F620:01CF9059]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-06-25 at 10:09 +0100, David Howells wrote:
> Paul Bolle <pebolle@tiscali.nl> wrote:
> > Perhaps AF_RXRPC should be dropped from this short list (it is selected
> > if AFS_FS is set). But since I couldn't actually determine how AFS_FS
> > and RXKAD interact I decided to not touch that list any further.
> 
> The key_type_rxrpc key that the AFS fs or userspace passes to AF_RXRPC
> indicates the protocol that AF_RXRPC should use.  The AFS fs doesn't need to
> care how the security actually works and the token is opaque to it.
> 
> rxkad registers itself with AF_RXRPC, which maintains a list.  The
> security_index is the number that appears in the protocol that indicates the
> security driver to use.

Thanks. That would have taken me quite a bit of time to figure out.

I'll leave that short list as is, unless you prefer that I send a v2
dropping AF_RXRPC.


Paul Bolle

