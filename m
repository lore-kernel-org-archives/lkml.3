Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755337Ab3JCTP1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 15:15:27 -0400
Received: from manchmal.in-ulm.de ([217.10.9.201]:42303 "EHLO
	manchmal.in-ulm.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755223Ab3JCTPY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 15:15:24 -0400
Date: Thu, 3 Oct 2013 21:15:20 +0200
From: Christoph Biedl <linux-kernel.bfrz@manchmal.in-ulm.de>
To: Khalid Aziz <khalid.aziz@oracle.com>
Cc: stable@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [ 00/13] 3.0.99-stable review
Message-ID: <1380827524@msgid.manchmal.in-ulm.de>
References: <20131003040400.753642257@linuxfoundation.org>
 <524D0663.209@roeck-us.net>
 <1380801873@msgid.manchmal.in-ulm.de>
 <524D72A7.8030200@oracle.com>
 <1380810793@msgid.manchmal.in-ulm.de>
 <524D85BA.9030603@oracle.com>
 <524D896F.7080801@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <524D896F.7080801@oracle.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Khalid Aziz wrote...

> Better yet, just pull this patch from stable from now. I will redo
> the patch and send another one for the next round.

FYI, after patching mm/swap.c accordingly, all the 3.0 and 3.4
configurations I use do build. Some boot tests will follow, I'll
follow up only if I see unusual behaviour.

    Christoph
