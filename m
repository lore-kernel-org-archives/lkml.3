Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932188AbbAIAHI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2015 19:07:08 -0500
Received: from mout.kundenserver.de ([212.227.17.13]:49656 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751011AbbAIAHG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2015 19:07:06 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Andy Gross <agross@codeaurora.org>, linux-arm-msm@vger.kernel.org,
        devicetree@vger.kernel.org, Kumar Gala <galak@codeaurora.org>,
        linux-kernel@vger.kernel.org,
        Bjorn Andersson <bjorn.andersson@sonymobile.com>
Subject: Re: [PATCH 1/2] soc: qcom: Add TCSR driver
Date: Fri, 09 Jan 2015 01:06:56 +0100
Message-ID: <4757751.7cLGsvPiZX@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1420757577-20425-2-git-send-email-agross@codeaurora.org>
References: <1420757577-20425-1-git-send-email-agross@codeaurora.org> <1420757577-20425-2-git-send-email-agross@codeaurora.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V03:K0:bmPzYv8R9NJWw88iU+w4UkV9wC8LvSOHOlHBzJDu/VmG1j1ZIwt
 8Oi9r35eLrdtTrRYCkHkOc0wf3JnxR32EwKsguN29wBfCDZXVAZ+BmuQ6u2aXg4tnSvREB6
 2GX4yyPdDm5UmsefrKC5QUemQII8KS+E+Fa4zQw3IXb2SDrNl2Xa3jd59HWRUc7Pf0sIknD
 Z5dg7c0zSaG2ClRlN/9Sg==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 08 January 2015 16:52:56 Andy Gross wrote:
> This patch adds support for the TCSR (Top Control and Status Register) IP block
> that is present in the Qualcomm IPQ8064, APQ8064, and some later processors.
> This block contains additional configuration and mux settings for various
> peripherals in the system, including the ADM DMA block and USB controller.
> 
> Signed-off-by: Andy Gross <agross@codeaurora.org>
> 

It sounds like this is a collection of random registers. Have you considered
making it a syscon node instead?

	Arnd
