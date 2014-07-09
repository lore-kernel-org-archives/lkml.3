Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755898AbaGIPmj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 11:42:39 -0400
Received: from mail-qg0-f44.google.com ([209.85.192.44]:49851 "EHLO
	mail-qg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755498AbaGIPmg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 11:42:36 -0400
Date: Wed, 9 Jul 2014 11:42:32 -0400
From: Tejun Heo <tj@kernel.org>
To: Alexandre Belloni <alexandre.belloni@free-electrons.com>
Cc: Antoine =?iso-8859-1?Q?T=E9nart?= 
	<antoine.tenart@free-electrons.com>,
        sebastian.hesselbarth@gmail.com, kishon@ti.com,
        thomas.petazzoni@free-electrons.com, zmxu@marvell.com,
        jszhang@marvell.com, linux-arm-kernel@lists.infradead.org,
        linux-ide@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>
Subject: Re: [PATCH v9 3/7] ata: libahci: allow to use multiple PHYs
Message-ID: <20140709154232.GC11193@htj.dyndns.org>
References: <1404728173-20263-1-git-send-email-antoine.tenart@free-electrons.com>
 <1404728173-20263-4-git-send-email-antoine.tenart@free-electrons.com>
 <20140708134000.GC4979@htj.dyndns.org>
 <20140708170353.GA16148@kwain>
 <20140708171817.GH4979@htj.dyndns.org>
 <20140708174900.GC16148@kwain>
 <20140708214010.GI4979@htj.dyndns.org>
 <20140709082331.GA4510@kwain>
 <20140709135910.GA11193@htj.dyndns.org>
 <20140709152446.GN3113@piout.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140709152446.GN3113@piout.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 09, 2014 at 05:24:46PM +0200, Alexandre Belloni wrote:
> Hi,
> 
> On 09/07/2014 at 09:59:10 -0400, Tejun Heo wrote :
> > Heh, I get that but, at the same time, this is the point where you're
> > most motivated to actually work on it.  :)
> > 
> 
> Or, starting that kind of review after 9 revisions, especially so close
> to the end of the development cycle is discouraging enough and will
> probably be used as an example of why we still have so many evil vendor
> trees.

Yeap, that's my bad.  I should have paid more attention.  Sorry about
that.  We still have quite a few weeks to go tho, so I don't think
it's too unreasonable to at least look into it.  We're gonna have to
do it anyway.

Thanks.

-- 
tejun
