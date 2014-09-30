Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752542AbaI3Sw4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 14:52:56 -0400
Received: from 80-229-23-162.plus.com ([80.229.23.162]:38878 "EHLO
	mail.einon.net" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1751042AbaI3Swy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 14:52:54 -0400
Date: Tue, 30 Sep 2014 19:52:50 +0100
From: Mark Einon <mark.einon@gmail.com>
To: Karthik Nayak <karthik.188@gmail.com>
Cc: linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
        gamerh2o@gmail.com, gregkh@linuxfoundation.org, mark.einon@gmail.com
Subject: Re: [PATCH] staging: bcm: multiple checkpatch fixes for
 InterfaceIdleMode.c
Message-ID: <20140930185250.GB1982@msilap.einon.net>
References: <1412097977-3254-1-git-send-email-karthik.188@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1412097977-3254-1-git-send-email-karthik.188@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 30, 2014 at 10:56:17PM +0530, Karthik Nayak wrote:
> 1. WARNING: else is not generally useful after a break or return
> 
> 2. WARNING: quoted string split across lines
> 
> 3. WARNING: break quoted strings at a space character
> 
> Signed-off-by: Karthik Nayak <karthik.188@gmail.com>
> ---

Hi again,

You probably wanted to send this patch to the maintainer of this driver,
instead of me. I suggest you re-run scripts/getmaintainer.pl on the patch.

Cheers,

Mark
