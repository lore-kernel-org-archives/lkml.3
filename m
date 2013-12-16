Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755155Ab3LPRno (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Dec 2013 12:43:44 -0500
Received: from mail-yh0-f49.google.com ([209.85.213.49]:52280 "EHLO
	mail-yh0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755122Ab3LPRnm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Dec 2013 12:43:42 -0500
Date: Mon, 16 Dec 2013 12:43:30 -0500
From: Tejun Heo <tj@kernel.org>
To: "Robin H. Johnson" <robbat2@gentoo.org>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: Re: [PATCH v2] libata: disable a disk via libata.force params
Message-ID: <20131216174330.GL32509@htj.dyndns.org>
References: <1386464187-6993-1-git-send-email-robbat2@gentoo.org>
 <1387215079-29897-1-git-send-email-robbat2@gentoo.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1387215079-29897-1-git-send-email-robbat2@gentoo.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 16, 2013 at 09:31:19AM -0800, Robin H. Johnson wrote:
> A user on StackExchange had a failing SSD that's soldered directly onto
> the motherboard of his system. The BIOS does not give any option to
> disable it at all, so he can't just hide it from the OS via the BIOS.
> 
> The old IDE layer had hdX=noprobe override for situations like this, but
> that was never ported to the libata layer.
> 
> This patch implements a disable flag for libata.force.
> Example use:
> libata.force=2.0:disable
> 
> [v2 of the patch, removed the nodisable flag per Tejun Heo]
> 
> Signed-off-by: Robin H. Johnson <robbat2@gentoo.org>
> X-URL: http://unix.stackexchange.com/questions/102648/how-to-tell-linux-kernel-3-0-to-completely-ignore-a-failing-disk
> X-URL: http://askubuntu.com/questions/352836/how-can-i-tell-linux-kernel-to-completely-ignore-a-disk-as-if-it-was-not-even-co
> X-URL: http://superuser.com/questions/599333/how-to-disable-kernel-probing-for-drive

Applied to libata/for-3.13-fixes w/ stable cc'd and minor description
edits.

Thanks.

-- 
tejun
