Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752155Ab3FYPR0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 11:17:26 -0400
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:51689 "EHLO
	out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751256Ab3FYPRY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 11:17:24 -0400
X-Sasl-enc: zzZhKAYUJFxB+UhQAEhGMxjljeD443Q3tDu78Hp39xsd 1372173443
Date: Tue, 25 Jun 2013 08:18:07 -0700
From: Greg KH <greg@kroah.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Rob Herring <rob.herring@calxeda.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>
Subject: Re: linux-next: manual merge of the usb tree with the devicetree tree
Message-ID: <20130625151807.GA20244@kroah.com>
References: <20130625165310.161dafbc62ab505ecbfc3cd3@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130625165310.161dafbc62ab505ecbfc3cd3@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 25, 2013 at 04:53:10PM +1000, Stephen Rothwell wrote:
> Hi Greg,
> 
> Today's linux-next merge of the usb tree got a conflict in
> drivers/usb/chipidea/Makefile between commit 8973ba8b325f ("usb:
> chipidea: depend on CONFIG_OF instead of CONFIG_OF_DEVICE") from the
> devicetree tree and commit 8e22978c5708 ("usb: chipidea: drop "13xxx"
> infix") from the usb tree.
> 
> I fixed it up (see below) and can carry the fix as necessary (no action
> is required).

Looks good to me, thanks,

greg k-h
