Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933539Ab3CTQmp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 12:42:45 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:46308 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752066Ab3CTQmn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 12:42:43 -0400
Message-ID: <1363797717.2580.10.camel@falcor1.watson.ibm.com>
Subject: Re: [PATCH 01/12] Security: Add CAP_COMPROMISE_KERNEL
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: James Morris <jmorris@namei.org>
Cc: Matthew Garrett <matthew.garrett@nebula.com>, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org, linux-efi@vger.kernel.org,
        kexec@lists.infradead.org, linux-pci@vger.kernel.org
Date: Wed, 20 Mar 2013 12:41:57 -0400
In-Reply-To: <alpine.LRH.2.02.1303191542200.30973@tundra.namei.org>
References: <1363642353-30749-1-git-send-email-matthew.garrett@nebula.com>
	 <alpine.LRH.2.02.1303191542200.30973@tundra.namei.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13032016-4834-0000-0000-000004E067D9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-03-19 at 15:47 +1100, James Morris wrote:
> On Mon, 18 Mar 2013, Matthew Garrett wrote:
> 
> > This patch introduces CAP_COMPROMISE_KERNEL. 
> 
> I'd like to see this named CAP_MODIFY_KERNEL, which is more accurate and 
> less emotive.  Otherwise I think core kernel developers will be scratching 
> their head over where to sprinkle this.
> 
> Apart from that, I like the idea, especially when it's wired up to MAC 
> security.

Matthrew, perhaps you could clarify whether this will be tied to MAC
security.  Based on the kexec thread, I'm under the impression that is
not the intention, or at least not for kexec.  As root isn't trusted,
neither is the boot command line, nor any policy that is loaded by root,
including those for MAC.

thanks,

Mimi

