Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934548AbaKMVzP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 16:55:15 -0500
Received: from mail-qa0-f53.google.com ([209.85.216.53]:53227 "EHLO
	mail-qa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934250AbaKMVzO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 16:55:14 -0500
Message-ID: <546528BF.5040902@gmail.com>
Date: Thu, 13 Nov 2014 16:55:11 -0500
From: Pranith Kumar <bobby.prani@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: David Howells <dhowells@redhat.com>
CC: "David S. Miller" <davem@davemloft.net>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>, paulmck@linux.vnet.ibm.com
Subject: Re: [PATCH 16/16] rxrpc: Replace smp_read_barrier_depends() with
 lockless_dereference()
References: <1415906662-4576-17-git-send-email-bobby.prani@gmail.com> <1415906662-4576-1-git-send-email-bobby.prani@gmail.com> <24601.1415911646@warthog.procyon.org.uk>
In-Reply-To: <24601.1415911646@warthog.procyon.org.uk>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/13/2014 03:47 PM, David Howells wrote:
> Pranith Kumar <bobby.prani@gmail.com> wrote:
> 
>> Recently lockless_dereference() was added which can be used in place of
>> hard-coding smp_read_barrier_depends(). The following PATCH makes the change.
> 
> Actually, the use of smp_read_barrier_depends() is wrong in circular
> buffering.  See Documentation/circular-buffers.txt
> 

OK. Should I send in a patch removing these barriers then?

--
Pranith

