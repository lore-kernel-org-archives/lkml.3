Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752687Ab3FNSz1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jun 2013 14:55:27 -0400
Received: from mx1.redhat.com ([209.132.183.28]:7126 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752973Ab3FNSzY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jun 2013 14:55:24 -0400
Date: Fri, 14 Jun 2013 14:54:54 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Michael Holzheu <holzheu@linux.vnet.ibm.com>
Cc: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>,
        Jan Willeke <willeke@de.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        linux-kernel@vger.kernel.org, kexec@lists.infradead.org
Subject: Re: [PATCH v5 0/5] kdump: Allow ELF header creation in new kernel
Message-ID: <20130614185454.GM12023@redhat.com>
References: <1370624161-2298-1-git-send-email-holzheu@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1370624161-2298-1-git-send-email-holzheu@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 07, 2013 at 06:55:56PM +0200, Michael Holzheu wrote:

[..]
> In this patch series I did not include the discussed ELF header swap trick
> patch because with the ELF header read functions this patch currently is
> not necessary.

Michael,

Would be good to this change atleast in a separate patch series so that
we have common mechanism across arches and understanding code becomes
easier.

Thanks
Vivek
