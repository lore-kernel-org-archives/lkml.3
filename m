Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030457Ab3HIHQi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Aug 2013 03:16:38 -0400
Received: from gate.crashing.org ([63.228.1.57]:48778 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S967344Ab3HIHQh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Aug 2013 03:16:37 -0400
Message-ID: <1376032572.32100.17.camel@pasglop>
Subject: Re: [PATCH 3/8] Add all memory via sysfs probe interface at once
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Nathan Fontenot <nfont@linux.vnet.ibm.com>
Cc: Michael Ellerman <michael@ellerman.id.au>, linux-mm <linux-mm@kvack.org>,
        isimatu.yasuaki@jp.fujitsu.com, linuxppc-dev@lists.ozlabs.org,
        LKML <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Date: Fri, 09 Aug 2013 17:16:12 +1000
In-Reply-To: <52016047.5060903@linux.vnet.ibm.com>
References: <51F01E06.6090800@linux.vnet.ibm.com>
	 <51F01EFB.6070207@linux.vnet.ibm.com> <20130802023259.GC1680@concordia>
	 <51FC04C2.70100@linux.vnet.ibm.com> <20130805031326.GB5347@concordia>
	 <52016047.5060903@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-08-06 at 15:44 -0500, Nathan Fontenot wrote:
> I am planning on pulling the first two patches and sending them out
> separate from the patch set since they are really independent of the
> rest of the patch series.
> 
> The remaining code I will send out for review and inclusion in
> linux-next so it can have the proper test time as you mentioned.

Ping ? :-)

Cheers,
Ben.


