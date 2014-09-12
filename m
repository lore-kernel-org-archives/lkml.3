Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752807AbaILUxX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 16:53:23 -0400
Received: from e38.co.us.ibm.com ([32.97.110.159]:58659 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751143AbaILUxV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 16:53:21 -0400
Message-ID: <1410555196.5187.223.camel@dhcp-9-2-203-236.watson.ibm.com>
Subject: Re: [Keyrings] [PATCH 1/9] Provide a binary to hex conversion
 function
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: David Howells <dhowells@redhat.com>
Cc: vgoyal@redhat.com, keyrings@linux-nfs.org, linux-kernel@vger.kernel.org
Date: Fri, 12 Sep 2014 16:53:16 -0400
In-Reply-To: <28503.1410553800@warthog.procyon.org.uk>
References: <1410552676.5187.211.camel@dhcp-9-2-203-236.watson.ibm.com>
	 <20140912190510.13239.90409.stgit@warthog.procyon.org.uk>
	 <20140912190515.13239.89507.stgit@warthog.procyon.org.uk>
	 <28503.1410553800@warthog.procyon.org.uk>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14091220-1344-0000-0000-0000042A2446
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-09-12 at 21:30 +0100, David Howells wrote: 
> Mimi Zohar <zohar@linux.vnet.ibm.com> wrote:
> 
> > How about using hex_byte_pack()?
> 
> It doesn't do a bufferful, only one byte.

The following code snippet is pretty common:

for (i = 0; i < count; i++)
bufptr = hex_byte_pack(bufptr, s[i]);

I'm suggesting making bin2hex() a wrapper for calling hex_byte_pack().

Mimi

