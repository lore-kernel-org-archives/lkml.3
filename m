Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758874Ab3EWS6a (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 May 2013 14:58:30 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49715 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758592Ab3EWS63 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 May 2013 14:58:29 -0400
Date: Thu, 23 May 2013 14:57:38 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Michael Holzheu <holzheu@linux.vnet.ibm.com>
Cc: Jan Willeke <willeke@de.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        linux-kernel@vger.kernel.org, kexec@lists.infradead.org
Subject: Re: [PATCH v2 1/3] kdump: Introduce ELF header in new memory feature
Message-ID: <20130523185738.GM2779@redhat.com>
References: <1369245517-16204-1-git-send-email-holzheu@linux.vnet.ibm.com>
 <1369245517-16204-2-git-send-email-holzheu@linux.vnet.ibm.com>
 <20130523174127.GA12290@redhat.com>
 <20130523205241.4b9e4fde@holzheu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130523205241.4b9e4fde@holzheu>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 23, 2013 at 08:52:41PM +0200, Michael Holzheu wrote:
> Hello Vivek,
> 
> Thanks for your reply. I will integrate your feedback into the v3 patch
> set and will make the following changes:
> 
> - Get rid of ELFCORE_ADDR_NEWMEM (sorry for that:)
> - Make read_from_crash_header() only read from kernel
> - Move read_from_crash_header() to weak function
>   arch_read_from_crash_header()
> - Implement read_from_crash_header() strong function for s390
> - Set elfcorehdr_addr to address of new ELF header

Thanks Michael. Also note, that hatayama has posted a  new version (V8)
of his mmap() patches. So you can rebase your changes on top of V8.

Thanks
Vivek
