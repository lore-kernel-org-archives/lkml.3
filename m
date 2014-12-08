Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755175AbaLHK52 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 05:57:28 -0500
Received: from smtp02.citrix.com ([66.165.176.63]:15170 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754761AbaLHK51 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 05:57:27 -0500
X-IronPort-AV: E=Sophos;i="5.07,537,1413244800"; 
   d="scan'208";a="201736067"
Message-ID: <54858415.80408@citrix.com>
Date: Mon, 8 Dec 2014 10:57:25 +0000
From: David Vrabel <david.vrabel@citrix.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.2.0
MIME-Version: 1.0
To: Juergen Gross <jgross@suse.com>, <linux-kernel@vger.kernel.org>,
        <xen-devel@lists.xensource.com>, <konrad.wilk@oracle.com>,
        <david.vrabel@citrix.com>, <boris.ostrovsky@oracle.com>
Subject: Re: [Xen-devel] [PATCH] xen: annotate xen_set_identity_and_remap_chunk()
 with __init
References: <1418016739-19305-1-git-send-email-jgross@suse.com>
In-Reply-To: <1418016739-19305-1-git-send-email-jgross@suse.com>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
X-DLP: MIA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/12/14 05:32, Juergen Gross wrote:
> Commit 5b8e7d80542487ff1bf17b4cf2922a01dee13d3a removed the __init
> annotation from xen_set_identity_and_remap_chunk(). Add it again.

Applied, thanks.

David
