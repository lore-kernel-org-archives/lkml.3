Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753102AbaENFvy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 01:51:54 -0400
Received: from e23smtp05.au.ibm.com ([202.81.31.147]:55079 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751117AbaENFvw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 01:51:52 -0400
Message-ID: <537303E4.4050903@linux.vnet.ibm.com>
Date: Wed, 14 May 2014 11:19:24 +0530
From: Anshuman Khandual <khandual@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Pedro Alves <palves@redhat.com>
CC: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org,
        michael@ellerman.id.au, mikey@neuling.org,
        Roland McGrath <roland@hack.frob.com>, avagin@openvz.org,
        oleg@redhat.com
Subject: Re: [PATCH V2 2/3] powerpc, ptrace: Enable support for transactional
 memory register sets
References: <1399276469-13541-1-git-send-email-khandual@linux.vnet.ibm.com> <1399276469-13541-3-git-send-email-khandual@linux.vnet.ibm.com> <5372547D.8040209@redhat.com>
In-Reply-To: <5372547D.8040209@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14051405-1396-0000-0000-000004D68515
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/13/2014 10:51 PM, Pedro Alves wrote:
> I wonder whether people are getting Roland's address from?
> 
> It's frequent that ptrace related patches end up CCed to
> roland@redhat.com, but, he's not been at Red Hat for a few years
> now.  Roland, do you still want to be CCed on ptrace-related
> issues?  If so, there's probably a script somewhere in the
> kernel that needs updating.  If not, well, it'd be good
> if it were updated anyway.  :-)
> 
> It's a little annoying, as Red Hat's servers outright reject
> email sent from a @redhat.com address if one tries to send
> an email that includes a CC/FROM to a user that no longer
> exists in the @redhat.com domain.

Got the email address from some of the previous ptrace related
commits.

