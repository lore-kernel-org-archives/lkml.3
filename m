Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755475AbaG3RSg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 13:18:36 -0400
Received: from mail-qg0-f45.google.com ([209.85.192.45]:42520 "EHLO
	mail-qg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755402AbaG3RSd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 13:18:33 -0400
Date: Wed, 30 Jul 2014 13:18:29 -0400
From: Tejun Heo <tj@kernel.org>
To: Antoine =?iso-8859-1?Q?T=E9nart?= 
	<antoine.tenart@free-electrons.com>
Cc: sebastian.hesselbarth@gmail.com, kishon@ti.com,
        alexandre.belloni@free-electrons.com,
        thomas.petazzoni@free-electrons.com, zmxu@marvell.com,
        jszhang@marvell.com, linux-arm-kernel@lists.infradead.org,
        linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v13 0/8] ARM: berlin: add AHCI support
Message-ID: <20140730171829.GF23734@htj.dyndns.org>
References: <1406739902-26311-1-git-send-email-antoine.tenart@free-electrons.com>
 <20140730170923.GE23734@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140730170923.GE23734@htj.dyndns.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 30, 2014 at 01:09:23PM -0400, Tejun Heo wrote:
> Hello,
> 
> Applied 3-5 to libata/for-3.17.  I suppose 6-8 are gonna routed
> through a different tree?

Reverted due to build failulre.  Can you please look into it?

Thanks.

-- 
tejun
