Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422667Ab3FUNjd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jun 2013 09:39:33 -0400
Received: from e06smtp15.uk.ibm.com ([195.75.94.111]:39123 "EHLO
	e06smtp15.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161367Ab3FUNjc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jun 2013 09:39:32 -0400
Date: Fri, 21 Jun 2013 15:39:24 +0200
From: Michael Holzheu <holzheu@linux.vnet.ibm.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>,
        Jan Willeke <willeke@de.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        linux-kernel@vger.kernel.org, kexec@lists.infradead.org
Subject: Re: [PATCH v5 0/5] kdump: Allow ELF header creation in new kernel
Message-ID: <20130621153924.1d3ad4c5@holzheu>
In-Reply-To: <20130614185454.GM12023@redhat.com>
References: <1370624161-2298-1-git-send-email-holzheu@linux.vnet.ibm.com>
	<20130614185454.GM12023@redhat.com>
Organization: IBM
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13062113-0342-0000-0000-0000056207D8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 14 Jun 2013 14:54:54 -0400
Vivek Goyal <vgoyal@redhat.com> wrote:

> On Fri, Jun 07, 2013 at 06:55:56PM +0200, Michael Holzheu wrote:
> 
> [..]
> > In this patch series I did not include the discussed ELF header swap trick
> > patch because with the ELF header read functions this patch currently is
> > not necessary.
> 
> Michael,
> 
> Would be good to this change atleast in a separate patch series so that
> we have common mechanism across arches and understanding code becomes
> easier.

Ok fine, we can do that in a separate patch series on top.

Michael

