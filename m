Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753176AbaBYRO4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 12:14:56 -0500
Received: from moutng.kundenserver.de ([212.227.126.130]:63742 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752653AbaBYROz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 12:14:55 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Kumar Gala <galak@codeaurora.org>
Subject: Re: [GIT PULL] qcom driver changes for v3.15
Date: Tue, 25 Feb 2014 18:14:43 +0100
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: arm@kernel.org, Kevin Hilman <khilman@linaro.org>,
        "linux-arm-msm" <linux-arm-msm@vger.kernel.org>,
        linux-kernel@vger.kernel.org, Rohit Vaswani <rvaswani@codeaurora.org>,
        Olof Johansson <olof@lixom.net>, David Brown <davidb@codeaurora.org>,
        linus.walleij@linaro.org, gnurou@gmail.com,
        herbert@gondor.apana.org.au, robdclark@gmail.com,
        linux-arm-kernel@lists.infradead.org
References: <alpine.DEB.2.00.1402250926210.17163@galak-ubuntu.qualcomm.com>
In-Reply-To: <alpine.DEB.2.00.1402250926210.17163@galak-ubuntu.qualcomm.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201402251814.43712.arnd@arndb.de>
X-Provags-ID: V02:K0:KejJG3D3Uq76G1sADAE96jd5+eypRodKOZwpovsbelA
 CTHM4mK4bQoWc11Xim+f0FbPOXEM/an7SbCCK7BTJ7a+nnPp3G
 5KLL+2v6DT1a49EqpyUTCjbb3cwlNdlzcmW9m6yG5hOfvnurM3
 KEapTHdJD5OXH2FaS/lqW7abdoNNCA+nA3pJl/3Sm3QnRsMmi2
 EySej7IZ7ANqUoONb4vwe6vXd15ngbENXtJ37ST6D9chpSbT5l
 sUXtlT9f/OChboLE/GmOFJSnpPhvQGaWe0MnwGm4p3WvWLDlhl
 Jjxyt+K3a+HommGlYYmL6QhaXNNRYU4YhjBo7/MUTRpgFCBKDs
 ur14t6VQE5wRDh5EV48E=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 25 February 2014, Kumar Gala wrote:
> The following changes since commit cf1e8f0cd665e2a9966d2bee4e11ecc0938ff166:
> 
>    ARM: qcom: Rename various msm prefixed functions to qcom (2014-02-06 16:20:41 -0600)
> 
> are available in the git repository at:
> 
>    git://git.kernel.org/pub/scm/linux/kernel/git/galak/linux-qcom.git tags/qcom-drivers-for-3.15
> 
> for you to fetch changes up to add798a40aec3a768165055477ba8bfee21e06fc:
> 
>    gpio: msm: switch Kconfig to ARCH_QCOM depends (2014-02-25 09:22:10 -0600)
> 

Applied to the next/drivers branch now, and added a merge description
that I adapted from your patch changelogs:

    Merge "qcom driver changes for v3.15" from Kumar Gala:
    
    We've split Qualcomm MSM support into legacy and multiplatform.  These
    drivers are only relevant on the multiplatform supported SoCs so switch the
    Kconfig depends to ARCH_QCOM.
    
It would be helpful if you can in the future always add a description
yourself when creating the tag.

	Arnd
