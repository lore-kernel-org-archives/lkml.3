Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754349Ab3CONlY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Mar 2013 09:41:24 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:57113 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753551Ab3CONlX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Mar 2013 09:41:23 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: David Miller <davem@davemloft.net>
Subject: Re: [PATCH] isdn: hisax: netjet requires VIRT_TO_BUS
Date: Fri, 15 Mar 2013 13:41:14 +0000
User-Agent: KMail/1.12.2 (Linux/3.8.0-8-generic; KDE/4.3.2; x86_64; ; )
Cc: geert@linux-m68k.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, isdn@linux-pingi.de,
        netdev@vger.kernel.org, dhowells@redhat.com
References: <201303151015.00746.arnd@arndb.de> <201303151229.52997.arnd@arndb.de> <20130315.083344.2224038988420448687.davem@davemloft.net>
In-Reply-To: <20130315.083344.2224038988420448687.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201303151341.14311.arnd@arndb.de>
X-Provags-ID: V02:K0:M4QjoEZspVVLNTmyIl1k4H4/4paoUMRuSMogJJHknhu
 PMrRcMPccqxUPiR1E4Gekiy9kjRDbsu2JRQz1gpyilsW2+Vw+7
 UT5GVf6r+4cqmTc6I+c5E3Y1f5DmppChVDTI1gwrTnW194fPqN
 fQLytJqTJbgVmGzIcYhofAePno0opmfzEu5DVVWIkhbdENQ0xM
 UxXUJagw7xAy+m5JsnVJrJdtFLlBMpz+7/jrBUb/yKdjTY04Y0
 W20hY1R0me7FlVBCF1tsmJES7p+yX0c8WGjPrCGyya/MTuOVSk
 yfckGRQsWpUI7WjwV+Q1R1T2d1acYMrz3HZ7pHt2o3FJHR9Xl6
 6KGKgaevjof4tEGOEoCE=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 15 March 2013, David Miller wrote:
> The first usage seems reason, but the temtation is going to be quite
> strong to misuse to block out drivers when there is "no value" in
> spending time necessary to simply make them endian clean instead.

Right. I'll let someone else start that discussion then if they
really want to see that patch.

	Arnd
