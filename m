Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752951AbaBJKO7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 05:14:59 -0500
Received: from mail-ea0-f170.google.com ([209.85.215.170]:39982 "EHLO
	mail-ea0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752889AbaBJKOy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 05:14:54 -0500
From: Peter Korsgaard <peter@korsgaard.com>
To: Wolfram Sang <wsa@the-dreams.de>
Cc: linux-i2c@vger.kernel.org, Peter Korsgaard <jacmet@sunsite.dk>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 11/17] i2c: i2c-ocores: deprecate class based instantiation
References: <1392026654-5343-1-git-send-email-wsa@the-dreams.de>
	<1392026654-5343-12-git-send-email-wsa@the-dreams.de>
Date: Mon, 10 Feb 2014 11:14:47 +0100
In-Reply-To: <1392026654-5343-12-git-send-email-wsa@the-dreams.de> (Wolfram
	Sang's message of "Mon, 10 Feb 2014 11:04:05 +0100")
Message-ID: <8738jr1dgo.fsf@dell.be.48ers.dk>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Wolfram" == Wolfram Sang <wsa@the-dreams.de> writes:

 > Warn users that class based instantiation is going away soon in favour
 > of more robust probing and faster bootup times.

 > Signed-off-by: Wolfram Sang <wsa@the-dreams.de>
 > Cc: Peter Korsgaard <jacmet@sunsite.dk>
 > ---

 > This patch is a suggestion. Looking for an ack by someone who actually uses
 > the driver.

It's been some time since I last used it, but I never needed the class
based probing, so:

Acked-by: Peter Korsgaard <jacmet@sunsite.dk>

-- 
Bye, Peter Korsgaard
