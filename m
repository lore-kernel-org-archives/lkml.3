Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752699Ab3FEGx4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 02:53:56 -0400
Received: from mout.gmx.net ([212.227.15.19]:53733 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752021Ab3FEGxz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 02:53:55 -0400
X-Authenticated: #7756412
X-Provags-ID: V01U2FsdGVkX1+EFz1KFJ+E80n7QJ8ioypP6WHgJLBh5+xmLEk9kI
	Kubx/9fEaB402t
Message-ID: <51AEE07E.6070301@gmx.net>
Date: Wed, 05 Jun 2013 08:53:50 +0200
From: Arne Jansen <sensille@gmx.net>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.18) Gecko/20110617 Lightning/1.0b2 Thunderbird/3.1.11
MIME-Version: 1.0
To: =?ISO-8859-1?Q?J=F6rn_Engel?= <joern@logfs.org>
CC: Chris Mason <clmason@fusionio.com>, Christoph Hellwig <hch@infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH 0/2] introduce list_for_each_entry_del
References: <1370280485-10047-1-git-send-email-joern@logfs.org> <20130603204930.GA28299@infradead.org> <20130603193647.GB10200@logfs.org> <20130603195555.GC10200@logfs.org> <20130604144856.GA12302@infradead.org> <20130604145322.4088.78915@localhost.localdomain> <51AE4969.8050709@gmx.net> <20130604184435.GA23436@logfs.org> <20130605020939.GC27240@logfs.org>
In-Reply-To: <20130605020939.GC27240@logfs.org>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05.06.2013 04:09, Jörn Engel wrote:
> On Tue, 4 June 2013 14:44:35 -0400, Jörn Engel wrote:
>>
>> Or while_list_drain?

I'm fine with while_list_drain, although a name starting with list_
like all other list macros would be nice. How about just list_drain?
The next question is where to put it in the header so that anyone
doing list cleanup stumbles upon it. Maybe directly below list_del?

-Arne

> 
> Not sure if the silence is approval or lack of interest, but a new set
> of patches is posted.  By playing around with the implementation a
> bit, I have actually found a variant that makes the object code
> shrink.  Not one variant gave same-size object code.  There's compiler
> optimization for you.
> 
> Jörn
> 
> --
> Money can buy bandwidth, but latency is forever.
> -- John R. Mashey

