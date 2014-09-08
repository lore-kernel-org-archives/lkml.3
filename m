Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754047AbaIHOEo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 10:04:44 -0400
Received: from smtp.citrix.com ([66.165.176.89]:3921 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753882AbaIHOEn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 10:04:43 -0400
X-IronPort-AV: E=Sophos;i="5.04,486,1406592000"; 
   d="scan'208";a="169328213"
Message-ID: <540DB6B0.9000503@citrix.com>
Date: Mon, 8 Sep 2014 15:01:20 +0100
From: David Vrabel <david.vrabel@citrix.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.5.0
MIME-Version: 1.0
To: Daniel Kiper <daniel.kiper@oracle.com>
CC: <linux-kernel@vger.kernel.org>, <xen-devel@lists.xenproject.org>,
        <boris.ostrovsky@oracle.com>, <konrad.wilk@oracle.com>
Subject: Re: [PATCH] xen/balloon: Remove unused pr_fmt() macro
References: <1410182638-18820-1-git-send-email-daniel.kiper@oracle.com> <540DAE71.4060902@citrix.com> <20140908135811.GI3459@olila.local.net-space.pl>
In-Reply-To: <20140908135811.GI3459@olila.local.net-space.pl>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-DLP: MIA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/09/14 14:58, Daniel Kiper wrote:
> On Mon, Sep 08, 2014 at 02:26:09PM +0100, David Vrabel wrote:
>> On 08/09/14 14:23, Daniel Kiper wrote:
>>> Remove unused pr_fmt() macro. Additionally, remove surplus empty
>>> lines which left after earlier various fixes and cleanups.
>>
>> A patch in the 3.17 queue uses this.
> 
> Hmmm... Which one? I am not able to find anything relevant in xen/tip.
> Am I missing something?

The balloon driver already uses it.  It is used in the pr_info() and
pr_warn() etc. macros.

David
