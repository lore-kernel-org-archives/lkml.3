Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932796Ab3DBP6W (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 11:58:22 -0400
Received: from mail-da0-f50.google.com ([209.85.210.50]:34966 "EHLO
	mail-da0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932352Ab3DBP6U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 11:58:20 -0400
Date: Tue, 2 Apr 2013 08:58:17 -0700
From: Olof Johansson <olof@lixom.net>
To: Martin Knoll <martinknoll@me.com>, stigge@antcom.de
Cc: linux@arm.linux.org.uk, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] ARM: LPC32xx: changed lpc23xx_restart to lpc32xx_restart
Message-ID: <20130402155817.GA25867@quad.lixom.net>
References: <1362601138-16550-1-git-send-email-martinknoll@me.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1362601138-16550-1-git-send-email-martinknoll@me.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 06, 2013 at 09:18:58PM +0100, Martin Knoll wrote:
> This function has an odd name. This is probably a typo.

You should cc the platform maintainer on these kind of patches (Roland Stigge).
But it seems that he's not actually listed in MAINTAINERS.

Roland, can you send a patch adding yourself as LPC32XX maintainer so these
kind of patches don't get dropped? Thanks!


-Olof
