Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752881AbaA3Lkp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jan 2014 06:40:45 -0500
Received: from smtp02.citrix.com ([66.165.176.63]:43766 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752687AbaA3Lko (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jan 2014 06:40:44 -0500
X-IronPort-AV: E=Sophos;i="4.95,749,1384300800"; 
   d="scan'208";a="96084099"
Message-ID: <52EA3A3C.4030209@citrix.com>
Date: Thu, 30 Jan 2014 11:40:44 +0000
From: =?ISO-8859-1?Q?Roger_Pau_Monn=E9?= <roger.pau@citrix.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Mukesh Rathor <mukesh.rathor@oracle.com>, <konrad.wilk@oracle.com>
CC: <Xen-devel@lists.xensource.com>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH V0] linux PVH: Set CR4 flags
References: <1391040918-11722-1-git-send-email-mukesh.rathor@oracle.com>
In-Reply-To: <1391040918-11722-1-git-send-email-mukesh.rathor@oracle.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.80.3.227]
X-DLP: MIA2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 30/01/14 00:15, Mukesh Rathor wrote:
> Konrad,
> 
> The CR4 settings were dropped from my earlier patch because you didn't
> wanna enable them. But since you do now, we need to set them in the APs
> also. If you decide not too again, please apply my prev patch
> "pvh: disable pse feature for now".

Hello Mukesh,

Could you push your CR related patches to a git repo branch? I'm
currently having a bit of a mess in figuring out which ones should be
applied and in which order.

Thanks, Roger.

