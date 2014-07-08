Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753730AbaGHBeg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 21:34:36 -0400
Received: from e23smtp04.au.ibm.com ([202.81.31.146]:41717 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751236AbaGHBef (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 21:34:35 -0400
Date: Tue, 8 Jul 2014 09:34:26 +0800
From: Wei Yang <weiyang@linux.vnet.ibm.com>
To: Christoph Lameter <cl@gentwo.org>
Cc: Wei Yang <weiyang@linux.vnet.ibm.com>,
        David Rientjes <rientjes@google.com>,
        Sasha Levin <sasha.levin@oracle.com>,
        Pekka Enberg <penberg@kernel.org>, Matt Mackall <mpm@selenic.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>, Dave Jones <davej@redhat.com>
Subject: Re: mm: slub: invalid memory access in setup_object
Message-ID: <20140708013426.GA18392@richard>
Reply-To: Wei Yang <weiyang@linux.vnet.ibm.com>
References: <53AAFDF7.2010607@oracle.com>
 <alpine.DEB.2.11.1406251228130.29216@gentwo.org>
 <alpine.DEB.2.02.1406301500410.13545@chino.kir.corp.google.com>
 <alpine.DEB.2.11.1407010956470.5353@gentwo.org>
 <20140702020454.GA6961@richard>
 <alpine.DEB.2.11.1407020918130.17773@gentwo.org>
 <20140703124015.GA17431@richard>
 <alpine.DEB.2.11.1407070850510.21323@gentwo.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.11.1407070850510.21323@gentwo.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14070801-9264-0000-0000-0000067E1F7A
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 07, 2014 at 08:51:08AM -0500, Christoph Lameter wrote:
>On Thu, 3 Jul 2014, Wei Yang wrote:
>
>> Here is my refined version, hope this is more friendly to the audience.
>
>Acked-by: Christoph Lameter <cl@linux.com>

Thanks. I am glad to work with you.

-- 
Richard Yang
Help you, Help me

