Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934793Ab3BTJuo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 04:50:44 -0500
Received: from moutng.kundenserver.de ([212.227.126.187]:57364 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933374Ab3BTJul (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 04:50:41 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Vinod Koul <vinod.koul@intel.com>
Subject: Re: [PATCH 0/4] dw_dmac: introduce generic DMA binding for DT
Date: Wed, 20 Feb 2013 09:50:25 +0000
User-Agent: KMail/1.12.2 (Linux/3.8.0-6-generic; KDE/4.3.2; x86_64; ; )
Cc: Dan Williams <djbw@fb.com>, linux-arm-kernel@lists.infradead.org,
        devicetree-discuss@lists.ozlabs.org,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Olof Johansson <olof@lixom.net>, linux-kernel@vger.kernel.org,
        Andy Shevchenko <andriy.shevchenko@linux.jf.intel.com>
References: <1360952512-971558-1-git-send-email-arnd@arndb.de> <20130220080348.GF23302@intel.com>
In-Reply-To: <20130220080348.GF23302@intel.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201302200950.26182.arnd@arndb.de>
X-Provags-ID: V02:K0:KzIGKSEU1aeBzPxu7TPeNm2tPk959k/p+2kz2fdtn1E
 EHEG+wahUHvk+xDJr9mK42M/2Qr9ADoh4AC7TZZQcCuOvV/zwe
 IEIT1ccBKCMiPhHdOLQgTJo/pFprj2gyegIulxdXSAwlAcXMpL
 LIEjtI+ahkr+s9DmNIOQTsPkyXAh4E4fR9cPnVxZtR+OjuHz68
 fvT0CxpiDTI3Vd9UVl7Dk4zMitRoBI9XrLc7FA0dC7I2+EAP8h
 gn4p2R96rtJLJEPmGA3VQ7YkMEZFZcXXmP4+Fkw5Ayov06U2BY
 mIn4HnxJGiqeigdvSZTx9D1UnV8MaYu9qSQBwRaWSfkak/iiNO
 2cP+Q8sfbFCs9qw9mY8o=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 20 February 2013, Vinod Koul wrote:
> Since there is still churn, would it make sense if I just revert the SPEAr13xx
> patch (your first patch) and send a pull request to Linus.
> Since there are no users and not much testing has been done, I think we can push
> these to 3.10 via arm-soc/slave-dma tree.
> 
> Gives more testing and usage will go along as well.
> Since merge window is open, I would like my pull to go soonish and not churn the
> tree much.

Reverting the SPEAr13xx would definitely help, yes. The reason why I'd also like
to see the second patch get merged is so that we can do the SPEAr changes in 3.10
without having an interdependency between the trees. I tried very hard to
make the patch have a minimal impact on the non-DT code path to avoid regressions.

Maybe you can send your tree now with just the revert applied, and then send the
other one separately next week along with any bug fixes that may have accumulated
by then?

	Arnd
