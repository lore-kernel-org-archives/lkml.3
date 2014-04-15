Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755088AbaDOOHf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 10:07:35 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:51547 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754743AbaDOOHd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 10:07:33 -0400
X-IronPort-AV: E=Sophos;i="4.97,864,1389744000"; 
   d="scan'208";a="120121379"
Message-ID: <534D3D19.6000503@citrix.com>
Date: Tue, 15 Apr 2014 15:07:21 +0100
From: David Vrabel <david.vrabel@citrix.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20121215 Iceowl/1.0b1 Icedove/3.0.11
MIME-Version: 1.0
To: Boris Ostrovsky <boris.ostrovsky@oracle.com>
CC: <konrad.wilk@oracle.com>, <xen-devel@lists.xenproject.org>,
        <linux-kernel@vger.kernel.org>, <srostedt@redhat.com>,
        <andrew.cooper3@citrix.com>, <JBeulich@suse.com>
Subject: Re: [PATCH v2] x86/xen: Fix 32-bit PV guests's usage of kernel_stack
References: <1397146629-7159-1-git-send-email-boris.ostrovsky@oracle.com> <5346E0E5.606@citrix.com> <5346F588.8050707@oracle.com>
In-Reply-To: <5346F588.8050707@oracle.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.80.2.76]
X-DLP: MIA2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/04/14 20:48, Boris Ostrovsky wrote:
> 
> %fs is pointing to per-cpu segment so %fs:xen_vcpu should be different
> on each (V)CPU.

Oh yes, of course.  Applied to stable/for-linus-3.15, thanks.

David
