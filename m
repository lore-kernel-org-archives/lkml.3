Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756681Ab3CQVNW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Mar 2013 17:13:22 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:63918 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756460Ab3CQVNT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Mar 2013 17:13:19 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Mike Turquette <mturquette@linaro.org>
Subject: Re: [PATCH 3.9-rc1] clk: vt8500: Fix variable name '*prate' compile error
Date: Sun, 17 Mar 2013 21:13:08 +0000
User-Agent: KMail/1.12.2 (Linux/3.8.0-8-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-arm-kernel@lists.infradead.org,
        Tim Gardner <tim.gardner@canonical.com>, linux-kernel@vger.kernel.org
References: <1361900052-66917-1-git-send-email-tim.gardner@canonical.com> <201303112207.32619.arnd@arndb.de> <20130317210123.8663.84457@quantum>
In-Reply-To: <20130317210123.8663.84457@quantum>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201303172113.08997.arnd@arndb.de>
X-Provags-ID: V02:K0:u3m/omdYJfzWVxjC/N8F88Z7vLIBhe/OD+0eAsSQB4a
 jvvKQbsUq/mikWRe6+r10ir3yni4/Amb/IaRux1Vk5k3xyu17n
 Uack6e9cp8/ABq1ppap1CbeSpT23wJhoYhQVoKUOHmTnaw3HJv
 nh50E5CK39dhxvCtXlbYTyFUqJjeRW2sOC7I8yzLWy2ea5PEo7
 4PNcXXubnNZsWdunHR9dHO5/HCM50/bo05C0pyh7UzufKlqMYQ
 S43fKBMOqqsHoaOUfaJbKvP5Uf35XiC4xo3TG9ckQbmT5/oGxF
 MBaDVvYzFoIpL22SukWpyvbeG4YMwsS8k49QexmdS17xZAR87l
 1SetGX3GJdO48G5xOLAo=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 17 March 2013, Mike Turquette wrote:
> Yes it is.  I haven't pushed a new branch out since 3.9-rc1 due to LCE
> and vacation after that.  This fix and other pending patches will get
> pulled in this week.
> 

I've actually put it into the arm-soc bug fix queue now, since I did not
hear back from you and it never showed up in linux-next.

	Arnd
