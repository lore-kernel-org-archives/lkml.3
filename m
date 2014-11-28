Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751281AbaK1Vin (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2014 16:38:43 -0500
Received: from mout.kundenserver.de ([212.227.126.187]:57312 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751183AbaK1Vil (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2014 16:38:41 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Liviu Dudau <Liviu.Dudau@arm.com>
Subject: Re: [PATCH] arm64: ARM: Fix the Generic Timers interrupt active level description
Date: Fri, 28 Nov 2014 22:38:36 +0100
User-Agent: KMail/1.12.2 (Linux/3.8.0-35-generic; KDE/4.3.2; x86_64; ; )
Cc: Marc Zyngier <Marc.Zyngier@arm.com>, Olof Johansson <olof@lixom.net>,
        Mark Rutland <Mark.Rutland@arm.com>,
        Rob Herring <robherring2@gmail.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Will Deacon <will.deacon@arm.com>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
References: <1417099005-18638-1-git-send-email-Liviu.Dudau@arm.com>
In-Reply-To: <1417099005-18638-1-git-send-email-Liviu.Dudau@arm.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201411282238.36406.arnd@arndb.de>
X-Provags-ID: V02:K0:l+lFwnlei8721Cy219mGbgr5xFVa5wr/mT7EyTMGZ0h
 kQZRU+d/THXf89xsnKmwXdG6BpeoD7f0BVhQUrvDFb5Z7CVqoU
 i6CWNAMOVoRNpVa/mS+soGb8TCO0Alx6j655i7Xi1fzPamOZMD
 F3vOhMj1DOEzbVM+/+f2K17yeEKh3F9O3qA8aU/ZFy37FxClVn
 Dh3dDkRPAX0R9dV1kS4Q4wXEo4HixmiF7MIC/+ZLnB3ibXsEqD
 BvSKdfp2eU1H69TYqT0QiLkXh65DZHQ6nSriMsqFXOsrWPDWde
 fS7Z75kmAycsZGs/Cwfj/TD3iUPvw9b+GABm7/4yfTgotcdGB+
 r79C0oJjMdfmtG9G4CoGTbZtB8KigJlqqMXV7tSWT
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 27 November 2014, Liviu Dudau wrote:
> The Cortex-A5x TRM states in paragraph "9.2 Generic Timer functional
> description" that generic timers provide an active-LOW interrupt
> output. Fix the device trees to correctly describe this.
> 
> While doing this update the CPU mask to match the number of described
> CPUs as well.
> 
> Signed-off-by: Liviu Dudau <Liviu.Dudau@arm.com>

Applied to next/arm64, thanks!

	Arnd
