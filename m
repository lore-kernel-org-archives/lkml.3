Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755368AbaG3R30 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 13:29:26 -0400
Received: from top.free-electrons.com ([176.31.233.9]:57542 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754350AbaG3R3Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 13:29:25 -0400
Date: Wed, 30 Jul 2014 19:29:11 +0200
From: Antoine =?iso-8859-1?Q?T=E9nart?= 
	<antoine.tenart@free-electrons.com>
To: Tejun Heo <tj@kernel.org>
Cc: Antoine =?iso-8859-1?Q?T=E9nart?= 
	<antoine.tenart@free-electrons.com>,
        sebastian.hesselbarth@gmail.com, kishon@ti.com,
        alexandre.belloni@free-electrons.com,
        thomas.petazzoni@free-electrons.com, zmxu@marvell.com,
        jszhang@marvell.com, linux-arm-kernel@lists.infradead.org,
        linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v13 0/8] ARM: berlin: add AHCI support
Message-ID: <20140730172911.GB15772@kwain>
References: <1406739902-26311-1-git-send-email-antoine.tenart@free-electrons.com>
 <20140730170923.GE23734@htj.dyndns.org>
 <20140730171829.GF23734@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20140730171829.GF23734@htj.dyndns.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 30, 2014 at 01:18:29PM -0400, Tejun Heo wrote:
> On Wed, Jul 30, 2014 at 01:09:23PM -0400, Tejun Heo wrote:
> > Hello,
> > 
> > Applied 3-5 to libata/for-3.17.  I suppose 6-8 are gonna routed
> > through a different tree?
> 
> Reverted due to build failulre.  Can you please look into it?

Sorry for that... I just fixed it. I'll test and send a new version.

Antoine

-- 
Antoine Ténart, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com
