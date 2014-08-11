Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752727AbaHKHSU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2014 03:18:20 -0400
Received: from mail-oi0-f46.google.com ([209.85.218.46]:39708 "EHLO
	mail-oi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752179AbaHKHST (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2014 03:18:19 -0400
MIME-Version: 1.0
In-Reply-To: <1406878723-28346-1-git-send-email-patrice.chotard@st.com>
References: <1406878723-28346-1-git-send-email-patrice.chotard@st.com>
Date: Mon, 11 Aug 2014 09:18:18 +0200
Message-ID: <CACRpkdb-A2Mg71e7Ws=pYcAdHCqoTpr3BrkWxm7OoiD5O8+18Q@mail.gmail.com>
Subject: Re: [PATCH] pinctrl: abx500: remove useless check
From: Linus Walleij <linus.walleij@linaro.org>
To: Patrice CHOTARD <patrice.chotard@st.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 1, 2014 at 9:38 AM, Patrice CHOTARD <patrice.chotard@st.com> wrote:

> pctldev can't be NULL at this stage so remove the check
>
> Reported-by: dan.carpenter@oracle.com
> Signed-off-by: Patrice Chotard <patrice.chotard@st.com>

Patch applied.

Yours,
Linus Walleij
