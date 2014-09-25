Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752792AbaIYX1L (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 19:27:11 -0400
Received: from mout.kundenserver.de ([212.227.126.130]:55071 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751875AbaIYX1K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 19:27:10 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Tony Prisk <linux@prisktech.co.nz>
Subject: Re: [PATCH] arm, vt8500, LLVMLlinux: Use mcr instead of mcr% for mach-vt8500
Date: Fri, 26 Sep 2014 01:26:59 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-35-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-arm-kernel@lists.infradead.org,
        Behan Webster <behanw@converseincode.com>, linux@arm.linux.org.uk,
        linux-kernel@vger.kernel.org
References: <1411530284-28807-1-git-send-email-behanw@converseincode.com> <7810937.UX61PvX9nB@wuerfel> <54230C1A.30801@prisktech.co.nz>
In-Reply-To: <54230C1A.30801@prisktech.co.nz>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="windows-1252"
Content-Transfer-Encoding: 7bit
Message-Id: <201409260127.00032.arnd@arndb.de>
X-Provags-ID: V02:K0:DJAJFzqzJaIPwHSH6iiugPBXjzvHEYcCI5NZYrcyIz4
 xBRW4Tzq+5llFtqe5LmSdi/ZrHBL6wqK8zkn3ZCracr9mWD75w
 uLeLeQMX8UD+B0GCVKJH8OjJeIrFdOvoEDIeIIXGAzgaD5+mWW
 CuNdtDyd4nZeC7SgMeMxiAs3LWj25qtQAQd8TWSBsrqtddGxOG
 UAT9TakBlUbysKZCimItbSj/BbJjUMjOo0lV9GsdD9KdVplHz0
 k4TlIngC1SsTgqKGfpkyT02Zrdkqe3BYidcxQ87qoXDhYw0hok
 IhDznuatbPtoSJLCLKs8cJwMsuMP+b5Zr4fwId8FG56UVaLKwH
 JPqARdJzQw/Hq6F63SnU=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 24 September 2014, Tony Prisk wrote:
> > Tony, would you like to pick this one up and send it in a pull request
> > to arm-soc, or should we apply it to fixes-non-critical directly?
> >
> >       Arnd
> Arnd,
> 
> You can apply it directly to fixes-non-critical if that's ok.

Applied, thanks!

	Arnd
