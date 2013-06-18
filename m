Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932337Ab3FRO41 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 10:56:27 -0400
Received: from mail-ob0-f172.google.com ([209.85.214.172]:48684 "EHLO
	mail-ob0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755725Ab3FRO4Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 10:56:25 -0400
MIME-Version: 1.0
In-Reply-To: <1371548973-7197-1-git-send-email-james.hogan@imgtec.com>
References: <1371548973-7197-1-git-send-email-james.hogan@imgtec.com>
Date: Tue, 18 Jun 2013 16:56:25 +0200
Message-ID: <CACRpkdayvBowVnjhK1WcRd3WzkuuE2G185NKEBimUEJH2-YcEw@mail.gmail.com>
Subject: Re: [PATCH] pinctrl: fix pinconf_ops::pin_config_dbg_parse_modify kerneldoc
From: Linus Walleij <linus.walleij@linaro.org>
To: James Hogan <james.hogan@imgtec.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 18, 2013 at 11:49 AM, James Hogan <james.hogan@imgtec.com> wrote:

> The kerneldoc comment for struct pinconf_ops was missing
> pin_config_dbg_parse_modify, and instead described
> pin_config_group_dbg_set (which is presumably an old name for the same
> function). Rename it in the kerneldoc comment so they match.
>
> Signed-off-by: James Hogan <james.hogan@imgtec.com>
> Cc: Linus Walleij <linus.walleij@linaro.org>

Patch applied.

Thanks,
Linus Walleij
