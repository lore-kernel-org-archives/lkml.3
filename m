Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752998AbbALLKe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 06:10:34 -0500
Received: from smtp.citrix.com ([66.165.176.89]:45712 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752928AbbALLKc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 06:10:32 -0500
X-IronPort-AV: E=Sophos;i="5.07,743,1413244800"; 
   d="scan'208";a="214692074"
Message-ID: <54B3ABA5.6090400@citrix.com>
Date: Mon, 12 Jan 2015 11:10:29 +0000
From: David Vrabel <david.vrabel@citrix.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.2.0
MIME-Version: 1.0
To: Juergen Gross <jgross@suse.com>, <linux-kernel@vger.kernel.org>,
        <xen-devel@lists.xensource.com>, <konrad.wilk@oracle.com>,
        <david.vrabel@citrix.com>, <boris.ostrovsky@oracle.com>,
        <jbeulich@suse.com>
Subject: Re: [Xen-devel] [Patch V2 0/4] xen: correct several bugs in new p2m
 list setup
References: <1421039110-11207-1-git-send-email-jgross@suse.com>
In-Reply-To: <1421039110-11207-1-git-send-email-jgross@suse.com>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
X-DLP: MIA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/01/15 05:05, Juergen Gross wrote:
> In the setup code of the linear mapped p2m list several bugs have
> been found, especially for 32 bit dom0. These patches correct the
> errors and make 32 bit dom0 bootable again.

Applied to stable/for-linus-3.19, thanks.

David
