Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755088Ab3HBTGI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 15:06:08 -0400
Received: from e23smtp01.au.ibm.com ([202.81.31.143]:50714 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752106Ab3HBTGG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 15:06:06 -0400
Message-ID: <51FC0315.1010601@linux.vnet.ibm.com>
Date: Fri, 02 Aug 2013 14:05:57 -0500
From: Nathan Fontenot <nfont@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130623 Thunderbird/17.0.7
MIME-Version: 1.0
To: Michael Ellerman <michael@ellerman.id.au>
CC: linux-mm <linux-mm@kvack.org>, isimatu.yasuaki@jp.fujitsu.com,
        linuxppc-dev@lists.ozlabs.org, LKML <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH 2/8] Mark powerpc memory resources as busy
References: <51F01E06.6090800@linux.vnet.ibm.com> <51F01EB2.9060802@linux.vnet.ibm.com> <20130802022827.GB1680@concordia>
In-Reply-To: <20130802022827.GB1680@concordia>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13080218-1618-0000-0000-000004640A0A
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/01/2013 09:28 PM, Michael Ellerman wrote:
> On Wed, Jul 24, 2013 at 01:36:34PM -0500, Nathan Fontenot wrote:
>> Memory I/O resources need to be marked as busy or else we cannot remove
>> them when doing memory hot remove.
> 
> I would have thought it was the opposite?

Me too.

As it turns out the code in kernel/resource.c checks to make sure the
IORESOURCE_BUSY flag is set when trying to release a resource.

-Nathan

