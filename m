Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753664Ab3H1Nu6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Aug 2013 09:50:58 -0400
Received: from mail-oa0-f53.google.com ([209.85.219.53]:65118 "EHLO
	mail-oa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752055Ab3H1Nu4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Aug 2013 09:50:56 -0400
MIME-Version: 1.0
In-Reply-To: <1377690982-11102-1-git-send-email-ldewangan@nvidia.com>
References: <1377690982-11102-1-git-send-email-ldewangan@nvidia.com>
Date: Wed, 28 Aug 2013 15:50:56 +0200
Message-ID: <CACRpkdao1QVFEmwVLT1ytf2Z2SBUr929ocWd1KV7vy=ExfK7Dg@mail.gmail.com>
Subject: Re: [PATCH] pinctrl: utils: include export.h to avoid warnings
From: Linus Walleij <linus.walleij@linaro.org>
To: Laxman Dewangan <ldewangan@nvidia.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 28, 2013 at 1:56 PM, Laxman Dewangan <ldewangan@nvidia.com> wrote:

> Include "linux/export.h" to avoid following warnings during compilation:

Patch applied.

Yours,
Linus Walleij
