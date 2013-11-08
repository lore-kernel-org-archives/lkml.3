Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756883Ab3KHJxr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Nov 2013 04:53:47 -0500
Received: from smtp.citrix.com ([66.165.176.89]:37481 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751874Ab3KHJxp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Nov 2013 04:53:45 -0500
X-IronPort-AV: E=Sophos;i="4.93,658,1378857600"; 
   d="scan'208";a="71960177"
Message-ID: <1383904422.3189.55.camel@kazak.uk.xensource.com>
Subject: Re: [PATCH 3.8 23/91] xen-netback: Don't destroy the netdev until
 the vif is shut down
From: Ian Campbell <Ian.Campbell@citrix.com>
To: Kamal Mostafa <kamal@canonical.com>
CC: <linux-kernel@vger.kernel.org>, <stable@vger.kernel.org>,
        <kernel-team@lists.ubuntu.com>, Paul Durrant <paul.durrant@citrix.com>,
        "David Vrabel" <david.vrabel@citrix.com>,
        Wei Liu <wei.liu2@citrix.com>
Date: Fri, 8 Nov 2013 09:53:42 +0000
In-Reply-To: <1383876946-2396-24-git-send-email-kamal@canonical.com>
References: <1383876946-2396-1-git-send-email-kamal@canonical.com>
	 <1383876946-2396-24-git-send-email-kamal@canonical.com>
Organization: Citrix Systems, Inc.
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.30.203.1]
X-DLP: MIA2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-11-07 at 18:14 -0800, Kamal Mostafa wrote:
> 3.8.13.13 -stable review patch.  If anyone has any objections, please let me know.

This patch caused a regression in the 3.10 stable tree. Two additional
patches were needed, see:
        http://www.spinics.net/lists/netdev/msg256637.html
        http://www.spinics.net/lists/netdev/msg256636.html

Ian.


