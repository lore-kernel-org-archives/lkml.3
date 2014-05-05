Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755528AbaEEJCp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 05:02:45 -0400
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:34902 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755129AbaEEJCc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 05:02:32 -0400
Date: Mon, 5 May 2014 10:01:26 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Andrey Ryabinin <a.ryabinin@samsung.com>
Cc: nicolas.pitre@linaro.org, will.deacon@arm.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] arm: put_user: fix possible data corruption in put_user
Message-ID: <20140505090126.GD3693@n2100.arm.linux.org.uk>
References: <1399270438-26181-1-git-send-email-a.ryabinin@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1399270438-26181-1-git-send-email-a.ryabinin@samsung.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 05, 2014 at 10:13:58AM +0400, Andrey Ryabinin wrote:
> According to arm procedure call standart r2 register is call-cloberred.
> So after the result of x expression was put into r2 any following
> function call in p may overwrite r2. To fix this, the result of p
> expression must be saved to the temporary variable before the
> assigment x expression to __r2.

This and the patch make no sense.  You talk about r2, but you're doing
nothing with r2 in the patch.

-- 
FTTC broadband for 0.8mile line: now at 9.7Mbps down 460kbps up... slowly
improving, and getting towards what was expected from it.
