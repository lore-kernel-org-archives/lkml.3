Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966666Ab3DROPj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Apr 2013 10:15:39 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:59827 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965049Ab3DROPi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Apr 2013 10:15:38 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: Re: [PATCH 18/19] ARM: at91: suspend both memory controllers on at91sam9263
Date: Thu, 18 Apr 2013 16:15:20 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-18-generic; KDE/4.3.2; x86_64; ; )
Cc: "Jean-Christophe Plagniol-Villard" <plagnioj@jcrosoft.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Andrew Victor <linux@maxim.org.za>,
        Albin Tonnerre <albin.tonnerre@free-electrons.com>
References: <1359123276-15833-1-git-send-email-arnd@arndb.de> <1359153858-31992-19-git-send-email-arnd@arndb.de> <516FF8FC.7070901@atmel.com>
In-Reply-To: <516FF8FC.7070901@atmel.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201304181615.20542.arnd@arndb.de>
X-Provags-ID: V02:K0:mBrg2x15Wqk+oZy3VGGn/Jt3Wuxo/KQFqobLWlQghBG
 DwBvTv+012S5qGWGBgEdJHuBLtl1/QgOAIy9ANgG37RbHfEvoq
 3dCaL+GB8aHTIm2WdH9eoVO4r5ND6Yj1uFWrRXZKENfvURRk4E
 KMlttNCN8fM64nKkywjsW0h0iLxhqyg1BiPkatZIbbTj7qOMEn
 2dfhKIm6VfpQVKgZxS8ucO9ZpkiHB+/Y1tqkC2nh/EOxayc/wu
 mxi2yJBvW+72J/XQOwZUUMA2lxRHVuTma1tKm+V0qEmTJYuSUK
 aSHWNwvtAtCyrM6i9Q+wRm64oJYuGDv9aAdGjK4iSpBXewQ0El
 xyBAM2D/DFRGIKk22mvg=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 18 April 2013, Nicolas Ferre wrote:

> > This patch blindly removes the warning and changes the
> > at91sam9263 to use the same code at at91sam9g45, which
> > may or may not be the right solution. If it is not,
> > maybe someone could provide a better fix.
> 
> Maybe you can remove this paragraph: now you are using the proper fix
> with proper RAM type.
> 
> > Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> > Cc: Nicolas Ferre <nicolas.ferre@atmel.com>
> 
> Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>
> 
> What is the future of this patch series: do you want us to take this
> patch separately or to you want to apply the whole series on the arm-soc
> tree?

I'd prefer if you could just apply or forward it to an appropriate tree.

Most of the other patches have found their way into mainline by now.

> > Cc: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>
> > Cc: Andrew Victor <linux@maxim.org.za>
> > Cc: Albin Tonnerre <albin.tonnerre@free-electrons.com>
> > Cc: Daniel Lezcano <daniel.lezcano@linaro.org>
> 
> Moreover, this patch my conflict with Daniel's current initiative to
> move cpuidle driver to its own directory: how do we coordinate with each
> other?

Maybe you can make sure it actually works and send it to Daniel to apply on
top of his other patches?

	Arnd
