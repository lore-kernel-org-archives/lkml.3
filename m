Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755748Ab3ANH7c (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2013 02:59:32 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:60732 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751916Ab3ANH7b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2013 02:59:31 -0500
Date: Mon, 14 Jan 2013 16:59:25 +0900
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Chanwoo Choi <cw00.choi@samsung.com>
Cc: MyungJoo Ham <myungjoo.ham@samsung.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Samuel Ortiz <sameo@linux.intel.com>,
        patches@opensource.wolfsonmicro.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/11] extcon-arizona updates
Message-ID: <20130114075923.GD4833@opensource.wolfsonmicro.com>
References: <20130110120231.GL20956@opensource.wolfsonmicro.com>
 <50EF71C3.6060009@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50EF71C3.6060009@samsung.com>
X-Cookie: Bridge ahead.  Pay troll.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 11, 2013 at 10:58:27AM +0900, Chanwoo Choi wrote:

> Applied this patch set.

> You can check this on extcon git repository:
> http://git.kernel.org/?p=linux/kernel/git/chanwoo/extcon.git;a=shortlog;h=refs/heads/for-next

Looks good.  It does seem this tree isn't in -next, though - if this
tree ends up getting sent to Linus (via Greg I guess?) it'd make sense
to do that so we get integration testing for it as soon as possible.
