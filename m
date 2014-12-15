Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752506AbaLOLqe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 06:46:34 -0500
Received: from smtp.citrix.com ([66.165.176.89]:54010 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752232AbaLOLqb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 06:46:31 -0500
X-IronPort-AV: E=Sophos;i="5.07,579,1413244800"; 
   d="scan'208";a="204396251"
Message-ID: <548ECA14.9040805@citrix.com>
Date: Mon, 15 Dec 2014 11:46:28 +0000
From: David Vrabel <david.vrabel@citrix.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.2.0
MIME-Version: 1.0
To: Juergen Gross <jgross@suse.com>, <linux-kernel@vger.kernel.org>,
        <x86@kernel.org>, <xen-devel@lists.xensource.com>,
        <konrad.wilk@oracle.com>, <david.vrabel@citrix.com>,
        <boris.ostrovsky@oracle.com>, <tglx@linutronix.de>, <mingo@redhat.com>,
        <hpa@zytor.com>, <mmarek@suse.cz>, <linux-kbuild@vger.kernel.org>
Subject: Re: [Xen-devel] [PATCH 3/4] xen: use generated hypervisor symbols
 in arch/x86/xen/trace.c
References: <1418321065-10212-1-git-send-email-jgross@suse.com> <1418321065-10212-4-git-send-email-jgross@suse.com>
In-Reply-To: <1418321065-10212-4-git-send-email-jgross@suse.com>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
X-DLP: MIA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/12/14 18:04, Juergen Gross wrote:
> Instead of manually list all hypervisor calls in arch/x86/xen/trace.c
> use the auto generated list.

Reviewed-by: David Vrabel <david.vrabel@citrix.com>

David
