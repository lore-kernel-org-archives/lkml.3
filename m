Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753284AbaEUTjJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 15:39:09 -0400
Received: from mail-qg0-f44.google.com ([209.85.192.44]:33433 "EHLO
	mail-qg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753204AbaEUTjI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 15:39:08 -0400
Date: Wed, 21 May 2014 15:39:04 -0400
From: Tejun Heo <tj@kernel.org>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sata_fsl: remove check for CONFIG_MPC8315_DS
Message-ID: <20140521193904.GE5259@htj.dyndns.org>
References: <1400700937.30334.2.camel@x220>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1400700937.30334.2.camel@x220>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 21, 2014 at 09:35:37PM +0200, Paul Bolle wrote:
> A check for CONFIG_MPC8315_DS was added in v2.6.24. But the related
> Kconfig symbol was never added to the tree. So the code behind this
> check has effectively been dead for over six years. Remove it.
> 
> Signed-off-by: Paul Bolle <pebolle@tiscali.nl>

Applied to libata/for-3.16.

Thanks.

-- 
tejun
