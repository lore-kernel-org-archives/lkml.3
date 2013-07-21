Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751431Ab3GUV1P (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Jul 2013 17:27:15 -0400
Received: from s15338416.onlinehome-server.info ([87.106.68.36]:59126 "EHLO
	order.stressinduktion.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751253Ab3GUV1O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Jul 2013 17:27:14 -0400
Date: Sun, 21 Jul 2013 23:27:13 +0200
From: Hannes Frederic Sowa <hannes@stressinduktion.org>
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Cc: netdev@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [BUG] ipv6, rawv6_close(): BUG: unable to handle kernel paging request
Message-ID: <20130721212713.GA6538@order.stressinduktion.org>
Mail-Followup-To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
	netdev@vger.kernel.org,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <51EC283D.5010208@linux.vnet.ibm.com> <20130721205352.GB15442@order.stressinduktion.org> <51EC4E4B.6040505@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <51EC4E4B.6040505@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 22, 2013 at 02:40:35AM +0530, Srivatsa S. Bhat wrote:
> On 07/22/2013 02:23 AM, Hannes Frederic Sowa wrote:
> > On Sun, Jul 21, 2013 at 11:58:13PM +0530, Srivatsa S. Bhat wrote:
> >> I'm seeing this on every boot.
> >>
> >> Version: Latest mainline (commit ea45ea70b)
> > 
> > Thanks for the report! Could you try the following patch?
> > 
> 
> That didn't seem to help :-(
> 
> Below is the new trace (not much different than the old one).

Ok, thanks. Do you have CONFIG_IPV6_MROUTE_MULTIPLE_TABLES enabled?

