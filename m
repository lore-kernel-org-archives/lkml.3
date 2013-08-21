Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752980Ab3HUWc4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 18:32:56 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:47734 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752419Ab3HUWcz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 18:32:55 -0400
MIME-Version: 1.0
In-Reply-To: <1377052130.20078.0.camel@phoenix>
References: <1377052130.20078.0.camel@phoenix>
Date: Thu, 22 Aug 2013 00:32:54 +0200
Message-ID: <CACRpkdY6ocD7dUpRyFfK3seHE2+Edb_QrbHMKnxCpo=EJkMq9w@mail.gmail.com>
Subject: Re: [PATCH] pinctrl: rockchip: Simplify for loop iteration
From: Linus Walleij <linus.walleij@linaro.org>
To: Axel Lin <axel.lin@ingics.com>
Cc: =?ISO-8859-1?Q?Heiko_St=FCbner?= <heiko@sntech.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 21, 2013 at 4:28 AM, Axel Lin <axel.lin@ingics.com> wrote:

> Just return once a match found makes the code simpler and shorter.
>
> Signed-off-by: Axel Lin <axel.lin@ingics.com>

Obviously correct, and elegant so patch applied.

Yours,
Linus Walleij
