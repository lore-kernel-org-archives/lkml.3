Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932802AbaIOWtw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 18:49:52 -0400
Received: from mail-pa0-f42.google.com ([209.85.220.42]:35304 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932775AbaIOWtt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 18:49:49 -0400
Message-ID: <54176D09.1040904@gmail.com>
Date: Tue, 16 Sep 2014 06:49:45 +0800
From: Chen Gang <gang.chen.5i5j@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: David Vrabel <david.vrabel@citrix.com>
CC: konrad.wilk@oracle.com, boris.ostrovsky@oracle.com,
        stefano.stabellini@eu.citrix.com, mukesh.rathor@oracle.com,
        xen-devel@lists.xenproject.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [Xen-devel] [PATCH 1/4] drivers/xen/xenbus/xenbus_client.c: Remove
 redundancy asignment to 'addr'
References: <54157282.40402@gmail.com> <541572BD.3040101@gmail.com> <5417089B.6030408@citrix.com>
In-Reply-To: <5417089B.6030408@citrix.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/15/2014 11:41 PM, David Vrabel wrote:
> On 14/09/14 11:49, Chen Gang wrote:
>> When failure occurs, 'node' is already set to NULL, and it is enough
>> for next checking (which will return in time), so need not set 'addr'.
> 
> I'm not going to apply this one.  The redundant assignment is harmless
> and improve clarity slightly, IMO.
> 

Hmm... maybe, it may depend on personal hobby, for me, only focusing one
'control' value (in our case is 'node') is more clearer than focusing
two 'control' values ('node' and 'addr').

In kernel conding styles, I feel (but I have no any proofs for it), it
is focus on performance, if one value need not be assigned, it need be
skipped.

But all together, I need respect the related maintainer's taste, if
he/she sticks to his/her taste.


Thanks.
-- 
Chen Gang

Open share and attitude like air water and life which God blessed
