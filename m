Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751456Ab3HTTbG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 15:31:06 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:38785 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751188Ab3HTTbE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 15:31:04 -0400
Date: Tue, 20 Aug 2013 15:30:56 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: David Vrabel <david.vrabel@citrix.com>
Cc: linux-kernel@vger.kernel.org, xen-devel@lists.xenproject.org,
        Chuck Anderson <chuck.anderson@oracle.com>
Subject: Re: [Xen-devel] [PATCH] xen/smp: initialize IPI vectors before
 marking CPU online
Message-ID: <20130820193056.GH12037@phenom.dumpdata.com>
References: <1376512905-8101-1-git-send-email-konrad.wilk@oracle.com>
 <520CD660.7060504@citrix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <520CD660.7060504@citrix.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 15, 2013 at 02:23:44PM +0100, David Vrabel wrote:
> On 14/08/13 21:41, Konrad Rzeszutek Wilk wrote:
> > From: Chuck Anderson <chuck.anderson@oracle.com>
> > 
> > An older PVHVM guest (v3.0 based) crashed during vCPU hot-plug with:
> > 
> > 	kernel BUG at drivers/xen/events.c:1328!
> 
> The commit message is perhaps a little wordy but this is better than
> being too short so.
> 
> Reviewed-by: David Vrabel <david.vrabel@citrix.com>

Thanks. I stuck it on the queue but somehow I forgot your reviewed-by. Sorry about that!
> 
> David
