Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752517AbaBNJOn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Feb 2014 04:14:43 -0500
Received: from mx1.redhat.com ([209.132.183.28]:15489 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752233AbaBNJOd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Feb 2014 04:14:33 -0500
Date: Fri, 14 Feb 2014 10:16:39 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: poma <pomidorabelisima@gmail.com>
Cc: Linux Kernel list <linux-kernel@vger.kernel.org>,
        linux-ide@vger.kernel.org,
        Mailing-List fedora-kernel <kernel@lists.fedoraproject.org>,
        Joerg Roedel <joro@8bytes.org>,
        Dan Williams <dan.j.williams@intel.com>, Tejun Heo <tj@kernel.org>,
        Gerard Roudier <groudier@club-internet.fr>,
        Alan Stern <stern@rowland.harvard.edu>,
        Josh Boyer <jwboyer@redhat.com>,
        "Justin M. Forbes" <jforbes@redhat.com>,
        Chris Murphy <lists@colorremedies.com>
Subject: Re: [dma-debug.c - DMA-API] =?utf-8?Q?exce?=
 =?utf-8?Q?eded_overlapping_=E2=80=A6_&_sym53c8xx_=E2=80=A6_tries_to_free_?=
 =?utf-8?B?RE1BIOKApg==?=
Message-ID: <20140214091639.GB1782@redhat.com>
References: <52FDD955.4000701@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <52FDD955.4000701@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 14, 2014 at 09:52:37AM +0100, poma wrote:
> 
> Ahoy!
> 
> Perhaps this is already solved, but I made ​​the effort to test & record
> all of this, therefore here you are. :)
> 
> https://bugzilla.redhat.com/show_bug.cgi?id=1062833

There is patch posted for this problem
http://marc.info/?l=linux-kernel&m=139233546223338&w=2
It is under review currently, if there will be no complains it will be
applied.

Stanislaw
