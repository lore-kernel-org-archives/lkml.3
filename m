Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754931Ab3FDOD0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 10:03:26 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:60125 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753861Ab3FDODX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 10:03:23 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: Re: [PATCH, resend] pch_phub: re-use native MAC address parser
Date: Tue, 4 Jun 2013 16:03:15 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
References: <1369756498-5670-1-git-send-email-andriy.shevchenko@linux.intel.com>
In-Reply-To: <1369756498-5670-1-git-send-email-andriy.shevchenko@linux.intel.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201306041603.15653.arnd@arndb.de>
X-Provags-ID: V02:K0:TjkBWSFIi45OoccUYc+ouh0NuTEBnfWJnM5I7xGiXHA
 RurTRe1AWay/+cdQKMI1UW64hOBEZIzKHRMMdbrRds8ZqvElRW
 jh7nB+mfn4UUPEL/drLLT+oSpDem/CDqOCwi79rSSrHkmMMxyu
 EnStL8wukxsrNo0UZdaKrgfaokBdUxdolb0xPgkbVUJag+2Sqt
 VL4RELJqYoRwZcHF6FK32fOkMueI9AMFzGYTeYozALbnM5dSbN
 K+2lQDJ/Qu3z7ElHgBDOMJazDtYEP06c23fIy86GjH+44JCZEU
 3hmmn79gPbU/JqvdJwLR/ClLFFxlml04kY8uKgxESY+QP3TNTc
 tOUUFocfWw2th2jIpRUo=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 28 May 2013, Andy Shevchenko wrote:
> We have mac_pton() helper to parse MAC addresses.
> 
> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> Acked-by: Arnd Bergmann <arnd@arndb.de>

Hmm, the patch has appeared in linux-next now, and I'm now getting
randconfig build errors when CONFIG_NET is disabled, since 
mac_pton is undefined then. The easiest solution would be to
make the entire driver "depend on NET".

	Arnd
