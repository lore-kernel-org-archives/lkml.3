Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754414Ab3EJTsN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 May 2013 15:48:13 -0400
Received: from mail-ia0-f172.google.com ([209.85.210.172]:45532 "EHLO
	mail-ia0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753172Ab3EJTsM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 May 2013 15:48:12 -0400
Date: Fri, 10 May 2013 11:58:32 -0700
From: Anton Vorontsov <anton@enomsg.org>
To: Mark Brown <broonie@kernel.org>
Cc: Axel Lin <axel.lin@ingics.com>, David Woodhouse <dwmw2@infradead.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] power_supply: wm831x_backup: Remove kfree call for
 devdata->backup.name
Message-ID: <20130510185831.GA3486@teo>
References: <1367647075.4394.1.camel@phoenix>
 <20130506103448.GD13472@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20130506103448.GD13472@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 06, 2013 at 11:34:48AM +0100, Mark Brown wrote:
> On Sat, May 04, 2013 at 01:57:55PM +0800, Axel Lin wrote:
> > devdata->backup.name points to devdata->name, the memory for devdata->name is
> > part of struct wm831x_backup. Thus remove kfree call for devdata->backup.name.
> 
> Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>

Applied, thanks a lot!

Anton
