Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751384AbaHDStl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 14:49:41 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:39384 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750714AbaHDStk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 14:49:40 -0400
Date: Mon, 4 Aug 2014 14:43:18 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: David Vrabel <david.vrabel@citrix.com>
Cc: gregkh@linuxfoundation.org, xen-devel@lists.xenproject.org,
        linux-kernel@vger.kernel.org, boris.ostrovsky@oracle.com
Subject: Re: [PATCH v5] Fixes to Xen pciback for 3.17.
Message-ID: <20140804184318.GB9009@laptop.dumpdata.com>
References: <1405354736-7358-1-git-send-email-konrad.wilk@oracle.com>
 <53DBB27D.2040203@citrix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53DBB27D.2040203@citrix.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 01, 2014 at 04:30:05PM +0100, David Vrabel wrote:
> On 14/07/14 17:18, Konrad Rzeszutek Wilk wrote:
> > Greg: goto GHK
> > 
> > This is v5 version of patches to fix some issues in Xen PCIback.
> 
> Applied to devel/for-linus-3.17.

Thank you.
> 
> I dropped the stable Cc for #2 pending a final decision on whether it
> really is a stable candidate.

OK.
> 
> David
