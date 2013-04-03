Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761547Ab3DCPfH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Apr 2013 11:35:07 -0400
Received: from mail-da0-f47.google.com ([209.85.210.47]:36717 "EHLO
	mail-da0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759456Ab3DCPfF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Apr 2013 11:35:05 -0400
Message-ID: <1365003300.13853.25.camel@edumazet-glaptop>
Subject: Re: [ 105/124] af_unix: dont send SCM_CREDENTIAL when dest socket
 is NULL
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Sven Joachim <svenjoac@gmx.de>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Ding Tianhong <dingtianhong@huawei.com>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>
Date: Wed, 03 Apr 2013 08:35:00 -0700
In-Reply-To: <87a9pfzm33.fsf@turtle.gmx.de>
References: <20130402221104.163133110@linuxfoundation.org>
	 <20130402221116.307254752@linuxfoundation.org>
	 <87vc833kpf.fsf@turtle.gmx.de> <1364997630.13853.19.camel@edumazet-glaptop>
	 <87a9pfzm33.fsf@turtle.gmx.de>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-04-03 at 17:10 +0200, Sven Joachim wrote:
> On 2013-04-03 16:00 +0200, Eric Dumazet wrote:

> 
> > It might be a wrong sender (application bug or bad identity), and udevd
> > correctly discards the incoming message.
> 
> How would I find out the culprit?

Change udevd to display the pid as well, and hopefully track the sender.

udevd receives uid and pid in the credentials.



