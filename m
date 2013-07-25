Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755401Ab3GYJ6q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jul 2013 05:58:46 -0400
Received: from mail-ee0-f45.google.com ([74.125.83.45]:49804 "EHLO
	mail-ee0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755301Ab3GYJ6l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jul 2013 05:58:41 -0400
Date: Thu, 25 Jul 2013 11:58:33 +0200
From: Fabio Baltieri <fabio.baltieri@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "John W. Linville" <linville@tuxdriver.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mac80211: use oneshot blink API for LED triggers
Message-ID: <20130725095833.GA21158@balto.lan>
References: <1374624581-6012-1-git-send-email-fabio.baltieri@gmail.com>
 <1374624581-6012-2-git-send-email-fabio.baltieri@gmail.com>
 <1374653665.8180.0.camel@jlt4.sipsolutions.net>
 <20130724085337.GA7096@balto.lan>
 <1374739101.8827.7.camel@jlt4.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1374739101.8827.7.camel@jlt4.sipsolutions.net>
X-Operating-System: Linux balto 3.11.0-rc2-00001-g765589b x86_64 GNU/Linux
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 25, 2013 at 09:58:21AM +0200, Johannes Berg wrote:
> > So, are you definitely rejecting this patch or should I fix indentation
> > and send a v2?
> 
> I think I'll take it, I kinda hope nobody will really care much about it
> but the behaviour looks better and the code is simpler, so ... :)

Good enough...  I'll send the v2 then. :-)

Thanks,
Fabio

-- 
Fabio Baltieri
