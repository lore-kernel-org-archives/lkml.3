Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756352Ab3GYPZn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jul 2013 11:25:43 -0400
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:24179 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755892Ab3GYPZm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jul 2013 11:25:42 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 72.84.113.162
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1/dBl+QXkBGu4mMgbLg1JBhMnppYE+e2NE=
Date: Thu, 25 Jul 2013 11:25:38 -0400
From: Jason Cooper <jason@lakedaemon.net>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ARM: dove: fix missing __init section of
 dove_mpp_gpio_mode
Message-ID: <20130725152538.GG23879@titan.lakedaemon.net>
References: <1372690572-2184-1-git-send-email-sebastian.hesselbarth@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1372690572-2184-1-git-send-email-sebastian.hesselbarth@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 01, 2013 at 04:56:12PM +0200, Sebastian Hesselbarth wrote:
> Legacy dove_mpp_gpio_mode calls orion_gpio_set_valid which is in
> __init section. Offending function is not, so this causes a section
> mismatch. To fix the mismatch, also move dove_mpp_gpio_mode to
> __init section.
> 
> Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
> ---
> Cc: Jason Cooper <jason@lakedaemon.net>
> Cc: linux-arm-kernel@lists.infradead.org
> Cc: linux-kernel@vger.kernel.org
> ---
>  arch/arm/mach-dove/mpp.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)

Applied to mvebu/fixes-non-critical

thx,

Jason.
