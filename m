Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751050AbaG1R1b (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 13:27:31 -0400
Received: from mail-qg0-f54.google.com ([209.85.192.54]:47819 "EHLO
	mail-qg0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750708AbaG1R13 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 13:27:29 -0400
Date: Mon, 28 Jul 2014 13:27:24 -0400
From: Tejun Heo <tj@kernel.org>
To: Hans de Goede <hdegoede@redhat.com>
Cc: Antoine =?iso-8859-1?Q?T=E9nart?= 
	<antoine.tenart@free-electrons.com>,
        sebastian.hesselbarth@gmail.com, kishon@ti.com,
        alexandre.belloni@free-electrons.com,
        thomas.petazzoni@free-electrons.com, zmxu@marvell.com,
        jszhang@marvell.com, linux-arm-kernel@lists.infradead.org,
        linux-ide@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v11 4/8] ata: libahci: allow to use multiple PHYs
Message-ID: <20140728172724.GA7462@htj.dyndns.org>
References: <1406193450-17283-1-git-send-email-antoine.tenart@free-electrons.com>
 <1406193450-17283-5-git-send-email-antoine.tenart@free-electrons.com>
 <53D62624.6070502@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53D62624.6070502@redhat.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 28, 2014 at 12:29:56PM +0200, Hans de Goede wrote:
...
> > +		if (!enabled_ports) {
> > +			dev_warn(dev, "No port enabled\n");
> > +			return ERR_PTR(-ENODEV);
> 
> This should be:
> 			rc = -ENODEV;
> 			goto err_out;
> 
> Sorry for not catching that sooner.
> 
> Other then that the entire series looks good and is:
> 
> Acked-by: Hans de Goede <hdegoede@redhat.com>

Antoine, can you please post an updated version of this patch?  No
need to repost the whole series.  Also, how should the series be
routed?

Thanks.

-- 
tejun
