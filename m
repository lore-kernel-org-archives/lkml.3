Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753420AbaFAVu0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jun 2014 17:50:26 -0400
Received: from mout.gmx.net ([212.227.17.20]:53022 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752441AbaFAVuZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jun 2014 17:50:25 -0400
Date: Sun, 1 Jun 2014 23:50:17 +0200
From: Christian Engelmayer <cengelma@gmx.at>
To: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
        Florian Schilhabel <florian.c.schilhabel@googlemail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Thomas Cort <linuxgeek@gmail.com>,
        Alexandre Demers <alexandre.f.demers@gmail.com>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: rtl8712: rtl871x_mlme.c:  Cleaning up memory
 leak
Message-ID: <20140601235017.289a8d4b@spike>
In-Reply-To: <1401622340-13453-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
References: <1401622340-13453-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K0:zjfZ64LWWRePjXhyq22dftjG+dyLMLnziv6nxf1Q0AT7WNjbJc4
 llvGiux3tcK9N0ZwwKLEZNA2sYznUVfAHot4Idh5CSWMC/KjffhKk3ZDRmOxTSHSq+7zcig
 LdLIGtILCCuMEIRbagt3HYmTM+EnnKurhbQA0mbgoWUcAQCJMdhW00wxGLCsPjJJpGqKpEK
 qnj3LrYYn+Atk2dod8u9A==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun,  1 Jun 2014 13:32:20 +0200, Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se> wrote:
> There is a risk for memory leak in when something unexpected happens
> and the function returns.
> 
> This was largely found by using a static code analysis program called cppcheck.
> 
> Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>

This doesn't apply against staging-next. This fix seems to attack the same
problem as existing commit 2af9e74 (staging: rtl8712: fix potential leaks in
r8712_set_key()) - http://www.spinics.net/lists/linux-driver-devel/msg46501.html

I think we talked about that already - see
http://www.spinics.net/lists/linux-driver-devel/msg46294.html

Regards,
Christian
