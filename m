Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753371AbaGJOc1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 10:32:27 -0400
Received: from mail-wi0-f176.google.com ([209.85.212.176]:36364 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750945AbaGJOc0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 10:32:26 -0400
From: Peter Korsgaard <peter@korsgaard.com>
To: Wolfram Sang <wsa@the-dreams.de>
Cc: linux-i2c@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Peter Korsgaard <jacmet@sunsite.dk>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 09/16] i2c: i2c-ocores: Drop class based scanning to improve bootup time
References: <1404992799-3705-1-git-send-email-wsa@the-dreams.de>
	<1404992799-3705-10-git-send-email-wsa@the-dreams.de>
Date: Thu, 10 Jul 2014 16:32:21 +0200
In-Reply-To: <1404992799-3705-10-git-send-email-wsa@the-dreams.de> (Wolfram
	Sang's message of "Thu, 10 Jul 2014 13:46:29 +0200")
Message-ID: <874mypp9my.fsf@dell.be.48ers.dk>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Wolfram" == Wolfram Sang <wsa@the-dreams.de> writes:

 > This driver has been flagged to drop class based instantiation. The removal
 > improves boot-up time and is unneeded for embedded controllers. Users have been
 > warned to switch for some time now, so we can actually do the removal. Keep the
 > DEPRECATED flag, so the core can inform users that the behaviour finally
 > changed now. After another transition period, this flag can go, too.
 > While we are here, remove the indentation for the array setup because
 > such things always break after some time.

 > Signed-off-by: Wolfram Sang <wsa@the-dreams.de>

Acked-by: Peter Korsgaard <peter@korsgaard.com>

-- 
Bye, Peter Korsgaard
