Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752100AbaJAVAJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2014 17:00:09 -0400
Received: from plane.gmane.org ([80.91.229.3]:50832 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751268AbaJAVAH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2014 17:00:07 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Dominik Kopp <my@kabelfunk.de>
Subject: Re: [BISECTED] (?) since 3.16: USB video cam of an HP Pavilion dv7 laptop not working
Date: Wed, 01 Oct 2014 22:51:15 +0200
Message-ID: <m0hpg3$5ih$1@ger.gmane.org>
References: <540DC871.7040901@web.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8Bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: pd952759f.dip0.t-ipconnect.de
User-Agent: KNode/4.11.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jörg-Volker Peetz wrote:

> Since 3.16 the builtin USB video cam of an HP Pavilion dv7 laptop shows
> only a black screen with the application guvcview although the video LED
> is turned on. There is no hint in dmesg. Also the output of guvcview shows
> no conspicuousness.
> 
> With kernel version 3.15.9 the camera works.
> 
> I tried to bisect between good v3.15 and bad v3.16, which identified
> 
> commit 9262c19d14c433a6a1ba25c3ff897cb89e412309
...
> 
> Thanks for any help,
> Jörg-Volker.

please have a look at
https://bugzilla.kernel.org/show_bug.cgi?id=81611

Due to a change in the driver, guvcview won't work with kernel 3.16.
You have to revert up to two kernel commits or use the latest version of 
guvcview (git version >2.0.0)

regards
Dominik Kopp

