Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753387Ab3HVDsR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 23:48:17 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:40841 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752461Ab3HVDsQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 23:48:16 -0400
Date: Wed, 21 Aug 2013 20:48:15 -0700 (PDT)
Message-Id: <20130821.204815.365691453186727923.davem@davemloft.net>
To: gregkh@linuxfoundation.org
Cc: daniel@gimpelevich.san-francisco.ca.us, j.dumon@option.com,
        linux-usb@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] hso: Earlier catch of error condition
From: David Miller <davem@davemloft.net>
In-Reply-To: <20130821162507.GD14364@kroah.com>
References: <1377074587.4530.8.camel@chimera>
	<20130821162507.GD14364@kroah.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.1 (shards.monkeyblade.net [0.0.0.0]); Wed, 21 Aug 2013 20:48:16 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>
Date: Wed, 21 Aug 2013 09:25:07 -0700

> On Wed, Aug 21, 2013 at 01:43:07AM -0700, Daniel Gimpelevich wrote:
>> There is no need to get an interface specification if we know it's the
>> wrong one. 
>> 
>> Signed-off-by: Daniel Gimpelevich <daniel@gimpelevich.san-francisco.ca.us>
> 
> Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

Applied.
