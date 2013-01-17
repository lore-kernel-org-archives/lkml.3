Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756199Ab3AQUBZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2013 15:01:25 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:52744 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755292Ab3AQUBY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2013 15:01:24 -0500
Date: Thu, 17 Jan 2013 15:01:22 -0500 (EST)
Message-Id: <20130117.150122.2295173415520467788.davem@davemloft.net>
To: keescook@chromium.org
Cc: linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org
Subject: Re: [PATCH 05/86] drivers/net/ethernet/seeq: remove depends on
 CONFIG_EXPERIMENTAL
From: David Miller <davem@davemloft.net>
In-Reply-To: <CAGXu5jJtkeOyjbUFtcycRAtFyykjLCUZ8s0ePM527SoNj_hkag@mail.gmail.com>
References: <1358391258-1771-6-git-send-email-keescook@chromium.org>
	<20130116.221108.1062607586895392221.davem@davemloft.net>
	<CAGXu5jJtkeOyjbUFtcycRAtFyykjLCUZ8s0ePM527SoNj_hkag@mail.gmail.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kees Cook <keescook@chromium.org>
Date: Thu, 17 Jan 2013 09:03:40 -0800

> On Wed, Jan 16, 2013 at 7:11 PM, David Miller <davem@davemloft.net> wrote:
>> Partially CC:'ing a mailing list for a subset of patches, without also
>> CC:'ing that list on your openning "00/xxx" email explaing what you're
>> doing and why is kind of pointless.
> 
> Hm? 0/86 got sent to lkml: https://lkml.org/lkml/2013/1/16/845
> 
> If you mean I didn't CC each of the people on the 0/86 email, yeah,
> that was intentional since it's a long list of people and lkml tends
> to drop emails with giant CC lists. I figured this was the sanest of
> the various sub-optional solutions.

Just CC: the relevant mailing lists.

Not everyone reads lkml, even I don't, it's too much noise and makes
me less effective in my work.
