Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757429Ab3BATu7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2013 14:50:59 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:38613 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754717Ab3BATuz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2013 14:50:55 -0500
Date: Fri, 01 Feb 2013 14:50:52 -0500 (EST)
Message-Id: <20130201.145052.1736779736271048954.davem@davemloft.net>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: pull request: wireless 2013-02-01
From: David Miller <davem@davemloft.net>
In-Reply-To: <20130201191745.GA29418@tuxdriver.com>
References: <20130201191745.GA29418@tuxdriver.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=euc-kr
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "John W. Linville" <linville@tuxdriver.com>
Date: Fri, 1 Feb 2013 14:17:45 -0500

> I'm sorry you got hit by the flu!  Hopefully you are fully recovered
> by now? :-)

I'm recovered enough to review everyone's buggy patches :-)

> This is a small batch of fixes intended for the 3.8 stream...
> 
> There are two pulls from Johannes.  Regarding mac80211, Johannes says:
> 
> "One fix from Dan for a possible memory overrun."
> 
> Regarding iwlwifi,  Johannes says:
> 
> "I have one fix from Emmanuel reverting a previous fix that caused
> more trouble than it's worth."
> 
> Along with those:
> 
> Arend van Spriel fixes a fatal error in brcsmac related to tx status processing.
> 
> Bing Zhao corrects a problem where mwifiex would fail to complete a scan
> in the event of an IE processing error.
> 
> Larry Finger fixes a thinko in rtlwifi in which the wrong skb variable
> was being used in some cases.
> 
> Rafa©© Mi©©ecki fixes a thinko in an ID check in the bcma flash code.

Pulled, thanks John.
