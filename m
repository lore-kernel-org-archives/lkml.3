Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932994Ab3DBSoP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 14:44:15 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:38295 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932220Ab3DBSoN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 14:44:13 -0400
X-Sasl-enc: alsYCJSjD5vwsJ44s4QogK6PdH+k0mWUyiHGbS9vdbus 1364928252
Date: Tue, 2 Apr 2013 11:44:11 -0700
From: Greg KH <greg@kroah.com>
To: Jonghwan Choi <jhbird.choi@samsung.com>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        "'Liam Girdwood'" <lrg@ti.com>,
        "'Mark Brown'" <broonie@opensource.wolfsonmicro.com>,
        "'Russ Dill'" <Russ.Dill@ti.com>
Subject: Re: [PATCH 3.8-stable] regulator: core: Log when a device causes a
 voltage
Message-ID: <20130402184411.GA21927@kroah.com>
References: <009001ce2f84$beb22ea0$3c168be0$%choi@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <009001ce2f84$beb22ea0$3c168be0$%choi@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 02, 2013 at 06:30:42PM +0900, Jonghwan Choi wrote:
> 3.8-stable review patch.  If anyone has any objections, please let us know.

Who is "us"?  :)

It's a bit nicer to say, "This patch looks like it should be in the
3.8-stable tree, should we apply it?"

That way, the default, if no one replies, is that the patch is not
applied (safer), not that it will be applied.  I need/require that the
authors/maintainers agree that any patch they don't explicitly mark for
the stable tree, yet people think it should be, to be acknowledged by
them.

thanks,

greg k-h
