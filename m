Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754240AbaAFKzh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 05:55:37 -0500
Received: from smtp02.citrix.com ([66.165.176.63]:31217 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753247AbaAFKzg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 05:55:36 -0500
X-IronPort-AV: E=Sophos;i="4.95,612,1384300800"; 
   d="scan'208";a="87836971"
Message-ID: <52CA8BA6.5040305@citrix.com>
Date: Mon, 6 Jan 2014 10:55:34 +0000
From: David Vrabel <david.vrabel@citrix.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20121215 Iceowl/1.0b1 Icedove/3.0.11
MIME-Version: 1.0
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: <xen-devel@lists.xenproject.org>, <linux-kernel@vger.kernel.org>,
        <boris.ostrovsky@oracle.com>, <stefano.stabellini@eu.citrix.com>,
        <hpa@zytor.com>
Subject: Re: [PATCH v13] Linux Xen PVH support (v13)
References: <1388777916-1328-1-git-send-email-konrad.wilk@oracle.com>
In-Reply-To: <1388777916-1328-1-git-send-email-konrad.wilk@oracle.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.80.2.76]
X-DLP: MIA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/01/14 19:38, Konrad Rzeszutek Wilk wrote:
> The patches, also available at
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/konrad/xen.git devel/pvh.v13

A minor nit with a comment but consider the complete series:

Reviewed-by: David Vrabel <david.vrabel@citrix.com>

I'm happy for this to go into 3.14.

David
