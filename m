Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752193AbbAPWhB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2015 17:37:01 -0500
Received: from mail-wg0-f44.google.com ([74.125.82.44]:56719 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751506AbbAPWg7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2015 17:36:59 -0500
From: Peter Korsgaard <peter@korsgaard.com>
To: Max Filippov <jcmvbkbc@gmail.com>
Cc: Peter Korsgaard <jacmet@sunsite.dk>, Wolfram Sang <wsa@the-dreams.de>,
        linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] i2c-ocores: add common clock support
References: <1421230899-7843-1-git-send-email-jcmvbkbc@gmail.com>
Date: Fri, 16 Jan 2015 23:36:50 +0100
In-Reply-To: <1421230899-7843-1-git-send-email-jcmvbkbc@gmail.com> (Max
	Filippov's message of "Wed, 14 Jan 2015 13:21:39 +0300")
Message-ID: <87wq4m9wu5.fsf@dell.be.48ers.dk>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Max" == Max Filippov <jcmvbkbc@gmail.com> writes:

 > Allow bus clock specification as a common clock handle. This makes this
 > controller easier to use in a setup based on common clock framework.

 > Signed-off-by: Max Filippov <jcmvbkbc@gmail.com>

Looks sensible to me - Thanks.

Acked-by: Peter Korsgaard <peter@korsgaard.com>

-- 
Bye, Peter Korsgaard
