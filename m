Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755196AbaGQIDZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 04:03:25 -0400
Received: from top.free-electrons.com ([176.31.233.9]:40835 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754866AbaGQIDQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 04:03:16 -0400
Date: Thu, 17 Jul 2014 10:03:02 +0200
From: Antoine =?iso-8859-1?Q?T=E9nart?= 
	<antoine.tenart@free-electrons.com>
To: Felipe Balbi <balbi@ti.com>
Cc: Antoine =?iso-8859-1?Q?T=E9nart?= 
	<antoine.tenart@free-electrons.com>,
        gregkh@linuxfoundation.org, Peter.Chen@freescale.com, kishon@ti.com,
        stern@rowland.harvard.edu, sergei.shtylyov@cogentembedded.com,
        yoshihiro.shimoda.uh@renesas.com, alexandre.belloni@free-electrons.com,
        thomas.petazzoni@free-electrons.com, zmxu@marvell.com,
        jszhang@marvell.com, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/8] usb: add support for the generic PHY framework
Message-ID: <20140717080302.GA3090@kwain>
References: <1405435156-27297-1-git-send-email-antoine.tenart@free-electrons.com>
 <20140716174513.GF3016@saruman.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20140716174513.GF3016@saruman.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Felipe,

On Wed, Jul 16, 2014 at 12:45:13PM -0500, Felipe Balbi wrote:
> On Tue, Jul 15, 2014 at 04:39:08PM +0200, Antoine Ténart wrote:
> > 
> > [1] https://www.mail-archive.com/linux-usb@vger.kernel.org/msg43471.html
> 
> Since this has a dependency on the other series which hasn't showed up
> with enough Acks, I can't take this one either. Let's get this ready
> early into v3.18-rc cycle so we don't miss this and the other series
> again.

Since this patch does not differ a lot from what I proposed, and is not
that big, can't we try to have acks in the next days so that we can take
this series as well? That would help my Berlin USB series[1] which
depends on this one :)

[1] http://lists.infradead.org/pipermail/linux-arm-kernel/2014-July/272840.html

Antoine

-- 
Antoine Ténart, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com
