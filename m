Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753734AbaIOPlV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 11:41:21 -0400
Received: from smtp.citrix.com ([66.165.176.89]:18568 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752691AbaIOPlU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 11:41:20 -0400
X-IronPort-AV: E=Sophos;i="5.04,529,1406592000"; 
   d="scan'208";a="171589493"
Message-ID: <5417089B.6030408@citrix.com>
Date: Mon, 15 Sep 2014 16:41:15 +0100
From: David Vrabel <david.vrabel@citrix.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.5.0
MIME-Version: 1.0
To: Chen Gang <gang.chen.5i5j@gmail.com>, <konrad.wilk@oracle.com>,
        <boris.ostrovsky@oracle.com>, David Vrabel <david.vrabel@citrix.com>,
        <stefano.stabellini@eu.citrix.com>, <mukesh.rathor@oracle.com>
CC: <xen-devel@lists.xenproject.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [Xen-devel] [PATCH 1/4] drivers/xen/xenbus/xenbus_client.c: Remove
 redundancy asignment to 'addr'
References: <54157282.40402@gmail.com> <541572BD.3040101@gmail.com>
In-Reply-To: <541572BD.3040101@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-DLP: MIA2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14/09/14 11:49, Chen Gang wrote:
> When failure occurs, 'node' is already set to NULL, and it is enough
> for next checking (which will return in time), so need not set 'addr'.

I'm not going to apply this one.  The redundant assignment is harmless
and improve clarity slightly, IMO.

David
