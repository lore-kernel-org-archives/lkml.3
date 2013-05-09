Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755618Ab3EINu1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 May 2013 09:50:27 -0400
Received: from terminus.zytor.com ([198.137.202.10]:53095 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755541Ab3EINuZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 May 2013 09:50:25 -0400
Message-ID: <518BA997.20401@zytor.com>
Date: Thu, 09 May 2013 06:50:15 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130311 Thunderbird/17.0.4
MIME-Version: 1.0
To: Denis Efremov <yefremov.denis@gmail.com>
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        linux-kernel@vger.kernel.org, x86@kernel.org, trivial@kernel.org,
        ldv-project@linuxtesting.org
Subject: Re: [PATCH 03/21] x86: remove inline marking of EXPORT_SYMBOL functions
References: <1368086241-9357-1-git-send-email-yefremov.denis@gmail.com> <1368086323-9412-3-git-send-email-yefremov.denis@gmail.com>
In-Reply-To: <1368086323-9412-3-git-send-email-yefremov.denis@gmail.com>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/09/2013 12:58 AM, Denis Efremov wrote:
> EXPORT_SYMBOL and inline directives are contradictory to each other.
> The patch fixes this inconsistency.
> 
> Found by Linux Driver Verification project (linuxtesting.org).

Nice, but wrong.

They aren't contradictory; in gnu89 syntax this means "this can be
inline, but also create an out-of-line copy that others can call."

That being said, I haven't looked at the code to see if that makes
sense, but the statement isn't correct.

	-hpa

