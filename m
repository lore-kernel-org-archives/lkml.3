Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753891AbaBZXjf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 18:39:35 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:41885 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751989AbaBZXjd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 18:39:33 -0500
Date: Wed, 26 Feb 2014 18:39:27 -0500 (EST)
Message-Id: <20140226.183927.1607497823277720839.davem@davemloft.net>
To: gregkh@linuxfoundation.org
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        jwboyer@fedoraproject.org, jslaby@suse.cz, akpm@linux-foundation.org,
        torvalds@linux-foundation.org
Subject: Re: 3.12-stable kernel tree being taken over by Jiri Slaby
From: David Miller <davem@davemloft.net>
In-Reply-To: <20140226231910.GA8789@kroah.com>
References: <20140226231910.GA8789@kroah.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Wed, 26 Feb 2014 15:39:33 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Date: Wed, 26 Feb 2014 15:19:10 -0800

> David, I don't know if you want to keep doing 3.12-networking patches or
> not, I'll let you work that out with Jiri directly.

3.12 and 3.13 are very similar, so the work is minimal, therefore I'm
likely to keep doing it.
