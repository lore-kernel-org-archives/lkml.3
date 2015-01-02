Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751995AbbABJa2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2015 04:30:28 -0500
Received: from mout.kundenserver.de ([212.227.17.24]:63564 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750714AbbABJa0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2015 04:30:26 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        Linus Walleij <linus.walleij@linaro.org>,
        Samuel Ortiz <sameo@linux.intel.com>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
        Grant Likely <grant.likely@linaro.org>,
        Lee Jones <lee.jones@linaro.org>
Subject: Re: [PATCH] mfd: db8500-prcmu:  Remove unused function
Date: Fri, 02 Jan 2015 10:30:16 +0100
Message-ID: <1885645.kVZgiLLSZ0@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1420134593-690-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
References: <1420134593-690-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V03:K0:0+SuxJT08cBrPcVHOQb0jFb7fQdEcD/gh2c/fKQWpw9mmF18kw0
 bWwvFtK/v36Y5CE7LsWonoHFuN8hXP7PCag6EQulIzvosYIYWr6nKwH9JSSHQOVF/1wyM01
 zy/t/QviW1Upjr4jBPL4jFQJ1dt2yMyvnc0IxpBvjIGMrWbY62z5aocKPm8+IThvFVTobun
 l7aaka5DnW+4c6lG8DHgw==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 01 January 2015 18:49:53 Rickard Strandqvist wrote:
> Remove the function prcmu_get_boot_status() that is not used anywhere.
> 
> This was partially found by using a static code analysis program called cppcheck.
> 
> Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
> 

Acked-by: Arnd Bergmann <arnd@arndb.de>
