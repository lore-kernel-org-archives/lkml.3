Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752103AbaBZJD3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 04:03:29 -0500
Received: from moutng.kundenserver.de ([212.227.17.24]:50663 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751106AbaBZJDS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 04:03:18 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: [PATCH, RFC 05/30] [media] omap_vout: avoid sleep_on race
Date: Wed, 26 Feb 2014 10:03:02 +0100
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, Mauro Carvalho Chehab <m.chehab@samsung.com>,
        linux-media@vger.kernel.org
References: <1388664474-1710039-1-git-send-email-arnd@arndb.de> <1388664474-1710039-6-git-send-email-arnd@arndb.de> <52D90490.3080407@xs4all.nl>
In-Reply-To: <52D90490.3080407@xs4all.nl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201402261003.03076.arnd@arndb.de>
X-Provags-ID: V02:K0:LtB3AXvPRjlQn5B0t14doP5obr0sBGaobBbyVVVDfW6
 gDZYezypA5e1+LKVDct/oSsXZHsCvMV6CVkO63ItTLN68rPpbW
 vFKoeoo9lPTGgPOh3FEacmTirl6olwtLJyfaIpfJujY9fl5ldN
 lH33vKgh+xLjybJpp4/FLk/zE+d3QZkK53l2EZ8D72VmevdgH+
 /LSGw4ZDSGhjSCyYvQp3lANwWA9UaabxsytsfZORnUH4SZVW/n
 saniF+01w1aR0CgWncs6/XXBGAE4OAiPWJCffdPO2d790OKRU5
 c8fnBt1u/5nLP0YZvwWVse46I5LOmQtN15pZW8BWUTxjEZ0ACA
 cSHZlJ+L42sVp5wFhv4s=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 17 January 2014, Hans Verkuil wrote:
> On 01/02/2014 01:07 PM, Arnd Bergmann wrote:
> > sleep_on and its variants are broken and going away soon. This changes
> > the omap vout driver to use interruptible_sleep_on_timeout instead,
> 
> I assume you mean wait_event_interruptible_timeout here :-)
> 
> Reviewed-by: Hans Verkuil <hans.verkuil@cisco.com>
> 
> If there are no other comments, then I plan to merge this next week.
> 

Hi Hans,

Not sure if you merged the media patches into a local tree, but I see
they are not in linux-next at the moment. I'll just re-send them,
but please let me know if I can drop them on my end, or better
make sure your tree is in linux-next if you have already picked them
up.

	Arnd
