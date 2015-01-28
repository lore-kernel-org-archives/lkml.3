Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933426AbbA1Ucq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 15:32:46 -0500
Received: from smtp.citrix.com ([66.165.176.89]:24109 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933389AbbA1Uco (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 15:32:44 -0500
X-IronPort-AV: E=Sophos;i="5.09,480,1418083200"; 
   d="scan'208";a="221185516"
Message-ID: <54C8B449.5080807@citrix.com>
Date: Wed, 28 Jan 2015 10:04:57 +0000
From: David Vrabel <david.vrabel@citrix.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.2.0
MIME-Version: 1.0
To: Juergen Gross <jgross@suse.com>, <linux-kernel@vger.kernel.org>,
        <xen-devel@lists.xensource.com>, <konrad.wilk@oracle.com>,
        <david.vrabel@citrix.com>, <boris.ostrovsky@oracle.com>
Subject: Re: [Xen-devel] [PATCH 0/5] xen: various cleanups
References: <1422427465-25239-1-git-send-email-jgross@suse.com>
In-Reply-To: <1422427465-25239-1-git-send-email-jgross@suse.com>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
X-DLP: MIA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 28/01/15 06:44, Juergen Gross wrote:
> Several cleanups in xen kernel files:
> - move declarations to header file
> - delete not needed lines
> - annotate functions as __init
> - make functions static
> - use correct types for addresses
> 
> No functional changes.

Applied to devel/for-linus-3.20, thanks.

David
