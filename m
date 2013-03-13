Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933061Ab3CMN7S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Mar 2013 09:59:18 -0400
Received: from mail-ia0-f173.google.com ([209.85.210.173]:59471 "EHLO
	mail-ia0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932358Ab3CMN7R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Mar 2013 09:59:17 -0400
MIME-Version: 1.0
In-Reply-To: <1362466733.9427.2.camel@phoenix>
References: <1362466733.9427.2.camel@phoenix>
Date: Wed, 13 Mar 2013 14:59:16 +0100
Message-ID: <CACRpkda-BvUQKPPC9rrQiG=p0OUtaqrtYp7uveBFopgqu_WdhQ@mail.gmail.com>
Subject: Re: [PATCH RFT] pinctrl: abx500: Fix checking if pin use
 AlternateFunction register
From: Linus Walleij <linus.walleij@linaro.org>
To: Axel Lin <axel.lin@ingics.com>
Cc: Lee Jones <lee.jones@linaro.org>, linux-kernel@vger.kernel.org,
        Patrice CHOTARD <patrice.chotard@st.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 5, 2013 at 7:58 AM, Axel Lin <axel.lin@ingics.com> wrote:

> It's pointless to check "af.alt_bit1 == UNUSED" twice.
> This looks like a copy-paste bug, I think what we want is to check if *both*
> af.alt_bit1 and af.alt_bit2 are UNUSED.
>
> Signed-off-by: Axel Lin <axel.lin@ingics.com>

Tentatively applied to fixes, waiting for Patrice to confirm...

Thanks!
Linus Walleij
