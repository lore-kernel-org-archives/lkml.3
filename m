Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753235AbaJFRtF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2014 13:49:05 -0400
Received: from mout.kundenserver.de ([212.227.17.24]:58315 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752251AbaJFRtD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2014 13:49:03 -0400
Date: Mon, 6 Oct 2014 19:48:55 +0200 (CEST)
From: Stefan Wahren <stefan.wahren@i2se.com>
Reply-To: Stefan Wahren <stefan.wahren@i2se.com>
To: Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, devicetree@vger.kernel.org
Message-ID: <1486422791.288728.1412617735622.JavaMail.open-xchange@oxbaltgw54.schlund.de>
Subject: Regulator: Questions about constraints
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Priority: 3
Importance: Medium
X-Mailer: Open-Xchange Mailer v7.6.0-Rev19
X-Originating-Client: com.openexchange.ox.gui.dhtml
X-Provags-ID: V02:K0:l8dNql5VjB63cqLM7gf1sPWAqlobL0x0Eqm40Oz7xjr
 tar2I22l9NFNPdzfMbcuYdoqmTdOEdTfifeCOBWfuGvMi8OanX
 vovn5xJqlR1heX19YIavO3vWym9tRBZG+UUmFbfCyxRNvIA+2T
 pVSc4lLx1aFry3VBK3oPOmh917ktASFL6LiCHKTzeKjyKlyxv1
 I+X7Qe5XtqzVM5vDc7ceymVL2uCcXyhzjgMXK44xGP4cIF6Nby
 h62anVgaVsHnte7rWwIofgMWxkaa5GFvDc66pmqUkCCmurTa+5
 FMoJkHkLcwIBlcY2R5tjYtbkodJHfyHbr2cXXi5CkAGCmvL7+S
 9L0VKBMuD2OzvN4RNNAdYLTkl1tDfVOGsQimREMMz3rWldG5Iu
 zLjbXNRokuhkHIwq+U4VsTapK4wblCGLuuPgiGQjeFMzYjL/wk
 tsIHPzjGxA1smaWux31mrV82jaQ==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

currently i'm porting a regulator driver and i've two question about regulator
constraints and DT binding:

Should a regulator driver rely on DT regulator constraints or not?

In case the constraints are not set by DT, what is the recommend behavior of a
regulator driver?

Best regards

Stefan
