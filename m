Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752456AbaBXKz5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 05:55:57 -0500
Received: from mx1.redhat.com ([209.132.183.28]:3178 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751559AbaBXKzy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 05:55:54 -0500
Message-ID: <1393239343.28750.3.camel@nilsson.home.kraxel.org>
Subject: Re: [PATCH v2 2/5] vmbus: add missing breaks
From: Gerd Hoffmann <kraxel@redhat.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: linux-fbdev@vger.kernel.org, gregkh@linuxfoundation.org,
        jasowang@redhat.com, linux-kernel@vger.kernel.org,
        tomi.valkeinen@ti.com,
        "open list:Hyper-V CORE AND..." <devel@linuxdriverproject.org>,
        haiyangz@microsoft.com
Date: Mon, 24 Feb 2014 11:55:43 +0100
In-Reply-To: <20140224104207.GG26722@mwanda>
References: <1393237516-28545-1-git-send-email-kraxel@redhat.com>
	 <1393237516-28545-3-git-send-email-kraxel@redhat.com>
	 <20140224104207.GG26722@mwanda>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mo, 2014-02-24 at 13:42 +0300, Dan Carpenter wrote:
> I'm sorry, I know it sucks to not get credit for fixes, but please just
> fold this into [patch 1/5].  We really should have a tag for this kind
> of thing.

It's not because of the credits, but because Greg picked up #1 into one
of his branches already (cover letter explains this).  I'll happily
submit a v3 with 1+2 squashed together if that doesn't ruin the patch
workflow.  Greg?

cheers,
  Gerd


