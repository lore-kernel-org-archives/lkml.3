Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755936Ab3H2Hsl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Aug 2013 03:48:41 -0400
Received: from mail-ob0-f181.google.com ([209.85.214.181]:62744 "EHLO
	mail-ob0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753740Ab3H2Hsk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Aug 2013 03:48:40 -0400
MIME-Version: 1.0
In-Reply-To: <1377741906.16018.1.camel@phoenix>
References: <1377741906.16018.1.camel@phoenix>
Date: Thu, 29 Aug 2013 09:48:40 +0200
Message-ID: <CACRpkdYWRVrC9sbSJFhXNJkU_O8+RxYw1qwN=w3-maOfP-cq=Q@mail.gmail.com>
Subject: Re: [PATCH] pinctrl: pinconf-generic: Remove ti prefix in dev_err messages
From: Linus Walleij <linus.walleij@linaro.org>
To: Axel Lin <axel.lin@ingics.com>
Cc: Laxman Dewangan <ldewangan@nvidia.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 29, 2013 at 4:05 AM, Axel Lin <axel.lin@ingics.com> wrote:

> It does not make sense to show ti prefix in pinconf_generic_dt_subnode_to_map()
> dev_err messages.
>
> Signed-off-by: Axel Lin <axel.lin@ingics.com>

Patch applied, probably a copy/paste bug.

Yours,
Linus Walleij
