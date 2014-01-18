Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756213AbaAWAiz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jan 2014 19:38:55 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:36799 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756143AbaAWAiQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jan 2014 19:38:16 -0500
User-Agent: K-9 Mail for Android
In-Reply-To: <1390011895-28123-1-git-send-email-mukesh.rathor@oracle.com>
References: <1390011895-28123-1-git-send-email-mukesh.rathor@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8BIT
Subject: Re: [V0 PATCH] xen/pvh: set some cr flags upon vcpu start
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Date: Fri, 17 Jan 2014 22:40:19 -0500
To: Mukesh Rathor <mukesh.rathor@oracle.com>
CC: roger.pau@citrix.com, Xen-devel@lists.xensource.com,
        linux-kernel@vger.kernel.org
Message-ID: <dd8e2ed3-4ddf-4f03-957f-902361234a66@email.android.com>
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mukesh Rathor <mukesh.rathor@oracle.com> wrote:
>Konrad,
>
>The following patch sets the bits in CR0 and CR4. Please note, I'm
>working
>on patch for the xen side. The CR4 features are not currently exported
>to a PVH guest. 

The patch should really have been split in two - one for CR0 and one for CR4.

Especially as the ramifications of enabling PGE are much more complex. For example - there is a need to  fix up the __supported_pte_mask to allow one to use PAGE_GLOBAL. There might be other things too that need tweaking.

>
>Roger, I added your SOB line, please lmk if I need to add anything
>else.
>
>This patch was build on top of a71accb67e7645c68061cec2bee6067205e439fc
>in
>konrad devel/pvh.v13 branch.

Pls use #linux-next at this stage.

Thank you!
>
>thanks
>Mukesh


