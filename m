Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754026AbaIHN0N (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 09:26:13 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:43582 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753081AbaIHN0M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 09:26:12 -0400
X-IronPort-AV: E=Sophos;i="5.04,486,1406592000"; 
   d="scan'208";a="170090155"
Message-ID: <540DAE71.4060902@citrix.com>
Date: Mon, 8 Sep 2014 14:26:09 +0100
From: David Vrabel <david.vrabel@citrix.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.5.0
MIME-Version: 1.0
To: Daniel Kiper <daniel.kiper@oracle.com>, <linux-kernel@vger.kernel.org>,
        <xen-devel@lists.xenproject.org>
CC: <boris.ostrovsky@oracle.com>, <konrad.wilk@oracle.com>
Subject: Re: [PATCH] xen/balloon: Remove unused pr_fmt() macro
References: <1410182638-18820-1-git-send-email-daniel.kiper@oracle.com>
In-Reply-To: <1410182638-18820-1-git-send-email-daniel.kiper@oracle.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-DLP: MIA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/09/14 14:23, Daniel Kiper wrote:
> Remove unused pr_fmt() macro. Additionally, remove surplus empty
> lines which left after earlier various fixes and cleanups.

A patch in the 3.17 queue uses this.

David
