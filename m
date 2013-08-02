Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753994Ab3HBTFL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 15:05:11 -0400
Received: from e23smtp06.au.ibm.com ([202.81.31.148]:36747 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751470Ab3HBTFJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 15:05:09 -0400
Message-ID: <51FC02D6.6050202@linux.vnet.ibm.com>
Date: Fri, 02 Aug 2013 14:04:54 -0500
From: Nathan Fontenot <nfont@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130623 Thunderbird/17.0.7
MIME-Version: 1.0
To: Michael Ellerman <michael@ellerman.id.au>
CC: linux-mm <linux-mm@kvack.org>, isimatu.yasuaki@jp.fujitsu.com,
        linuxppc-dev@lists.ozlabs.org, LKML <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH 1/8] register bootmem pages for powerpc when sparse vmemmap
 is not defined
References: <51F01E06.6090800@linux.vnet.ibm.com> <51F01E5F.80307@linux.vnet.ibm.com> <20130802022703.GA1680@concordia>
In-Reply-To: <20130802022703.GA1680@concordia>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13080218-7014-0000-0000-0000036A73F1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/01/2013 09:27 PM, Michael Ellerman wrote:
> On Wed, Jul 24, 2013 at 01:35:11PM -0500, Nathan Fontenot wrote:
>> Previous commit 46723bfa540... introduced a new config option
>> HAVE_BOOTMEM_INFO_NODE that ended up breaking memory hot-remove for powerpc
>> when sparse vmemmap is not defined.
> 
> So that's a bug fix that should go into 3.10 stable?
> 

Yes, I believe this one as well as patch 2/8 should go into 3.10 stable.

I'll re-send with linux stable added.

-Nathan

