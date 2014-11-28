Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751534AbaK1Lbr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2014 06:31:47 -0500
Received: from mout.kundenserver.de ([212.227.126.130]:60624 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751300AbaK1Lbq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2014 06:31:46 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Maxime Coquelin <maxime.coquelin@st.com>
Subject: Re: [PATCH] MAINTAINERS: Add ahci_st.c to ARCH/STI architecture
Date: Fri, 28 Nov 2014 12:31:31 +0100
User-Agent: KMail/1.12.2 (Linux/3.8.0-35-generic; KDE/4.3.2; x86_64; ; )
Cc: Peter Griffin <peter.griffin@linaro.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        patrice.chotard@st.com, srinivas.kandagatla@gmail.com,
        olof Johansson <olof@lixom.net>, lee.jones@linaro.org
References: <1416386694-7402-1-git-send-email-peter.griffin@linaro.org> <5475DA1C.50307@st.com>
In-Reply-To: <5475DA1C.50307@st.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="windows-1252"
Content-Transfer-Encoding: 7bit
Message-Id: <201411281231.31920.arnd@arndb.de>
X-Provags-ID: V02:K0:upstcDXihVNUIcE0wS1IgAZxvAQuCGAbvZGNOICbSUK
 XMtV2Eks36z9evhKWJv2hPObI7AN3AuuJI35TFSGVunMgBVR/x
 wcAdl4ZYeGEUApayLicXu0eLAGRxCpUV/jWw6/ClNbxjCtVMk/
 bdBwCS5Yetw5/YqrMO2oFVEPDBtO8lGYdz5Y8I0utbvQQLLpx4
 F4CLMFnt0O0dOluJOTTK86xl1eX54OhE/K96p8yCGpbeeJ5LOA
 GcEGGZrVuhbadk4RBhBF/5KG+y6zgBchnVvgDYSj9e29NqGpgm
 voGVSxwgftgK5gYy1/dj4BaJBWmw7FWWCzKqb3b1wEGDw6ci0q
 IPu2hOZEtBs6Jc48xTF/UcisKP1pODUTKzEa4M9h7
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 26 November 2014, Maxime Coquelin wrote:
> On 11/19/2014 09:44 AM, Peter Griffin wrote:
> > This patch adds the ahci_st.c driver found on STMicroelectronics
> > stih41x consumer electronics SoC's into the STI arch section
> > of the maintainers file.
> >
> > Signed-off-by: Peter Griffin <peter.griffin@linaro.org>
> Acked-by: Maxime Coquelin <maxime.coquelin@st.com>
> 
> Arnd, Olof, could you pick this one directly?
> I only have this single patch remaining for v3.19, so didn't planned to 
> send another pull-request.
> 

Applied to next/fixes-non-critical now with the two Acks, thanks!

	Arnd
