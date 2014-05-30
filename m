Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933193AbaE3Nz2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 09:55:28 -0400
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:39680 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932413AbaE3Nz1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 09:55:27 -0400
Date: Fri, 30 May 2014 14:53:22 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: mathieu.poirier@linaro.org
Cc: linus.walleij@linaro.org, will.deacon@arm.com, arve@android.com,
        john.stultz@linaro.org, pratikp@codeaurora.org, varshney@ti.com,
        Al.Grant@arm.com, jonas.svennebring@avagotech.com,
        james.king@linaro.org, panchaxari.prasannamurthy@linaro.org,
        arnd@linaro.org, marcin.jabrzyk@gmail.com, r.sengupta@samsung.com,
        robbelibobban@gmail.com, patches@linaro.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        daniel.thompson@linaro.org
Subject: Re: [RFC PATCH 04/11] coresight: add CoreSight ETB driver
Message-ID: <20140530135321.GQ3693@n2100.arm.linux.org.uk>
References: <1401457391-12242-1-git-send-email-mathieu.poirier@linaro.org> <1401457391-12242-5-git-send-email-mathieu.poirier@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1401457391-12242-5-git-send-email-mathieu.poirier@linaro.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

NAK for all the reasons I mentioned in the previous submission in 2012.

You partially did the right thing - you read through the previous
submission, and you said in your cover message that you had addressed
some of the comments from that submission.

What I find extremely distasteful is that you seem to have chosen to
completely ignore my comments - you haven't mentioned them in your
covering message at all, and you've just gone ahead and converted ETM
and ETB to be platform devices.

That gets you a NAK for that change, because you have done nothing what
so ever to address the concerns I raised.

Since you seem to have ignored my comments, this is as far as I'm looking
at your submission, and you can consider the entire submission NAK'd by
me.

Thanks.

-- 
FTTC broadband for 0.8mile line: now at 9.7Mbps down 460kbps up... slowly
improving, and getting towards what was expected from it.
