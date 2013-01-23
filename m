Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755353Ab3AWNEt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2013 08:04:49 -0500
Received: from kiruna.synopsys.com ([198.182.44.80]:40956 "EHLO
	kiruna.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755122Ab3AWNEr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2013 08:04:47 -0500
Message-ID: <50FFDF85.9070600@synopsys.com>
Date: Wed, 23 Jan 2013 18:33:01 +0530
From: Vineet Gupta <Vineet.Gupta1@synopsys.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: David Howells <dhowells@redhat.com>
CC: <linux-arch@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <arnd@arndb.de>
Subject: Re: [PATCH v2 65/76] ARC: UAPI Disintegrate arch/arc/include/asm
References: <50FFCAC4.1050002@synopsys.com> <1358511930-7424-1-git-send-email-vgupta@synopsys.com> <1358511930-7424-66-git-send-email-vgupta@synopsys.com> <10760.1358945425@warthog.procyon.org.uk>
In-Reply-To: <10760.1358945425@warthog.procyon.org.uk>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.12.197.205]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 23 January 2013 06:20 PM, David Howells wrote:
> Vineet Gupta <Vineet.Gupta1@synopsys.com> wrote:
>
>> I generated this patch using the scripts you provided. If these look OK to
>> you, can you please ACK.
> You need to take a look at uapi/asm/setup.h.  It's created as an empty file -
> which will get discarded by patch.  Do you actually need a UAPI instance of
> that?
>
> David

Nope, I don't - but ./genfilelist.pl seems to be generating a reference to it
(even if I add #ifdef __KERNEL__)
How do I work around this ! Do I skip it when running ./disintegrate-one.pl - but
then it won't be completely scripted :-(

-Vineet

