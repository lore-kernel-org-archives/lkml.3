Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754949Ab3G2QPq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jul 2013 12:15:46 -0400
Received: from mail-gg0-f178.google.com ([209.85.161.178]:39323 "EHLO
	mail-gg0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753682Ab3G2QPn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jul 2013 12:15:43 -0400
Date: Mon, 29 Jul 2013 12:15:37 -0400
From: Tejun Heo <tj@kernel.org>
To: Niels de Vos <ndevos@redhat.com>
Cc: devicetree@vger.kernel.org, linux-ide@vger.kernel.org,
        linux-kernel@vger.kernel.org, Sascha Hauer <s.hauer@pengutronix.de>
Subject: Re: [PATCH] pata_imx: expose module alias for loading from
 device-tree
Message-ID: <20130729161537.GE22605@mtj.dyndns.org>
References: <1375083518-14899-1-git-send-email-ndevos@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1375083518-14899-1-git-send-email-ndevos@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 29, 2013 at 09:38:38AM +0200, Niels de Vos wrote:
> Enable auto loading by udev when pata_imx is compiled as a module.
> 
> Signed-off-by: Niels de Vos <ndevos@redhat.com>
> Cc: Sascha Hauer <s.hauer@pengutronix.de>

Applied to libata/for-3.11-fixes.

Thanks.

-- 
tejun
