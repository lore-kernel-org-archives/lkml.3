Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933174Ab3E1GuI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 02:50:08 -0400
Received: from mail-ie0-f182.google.com ([209.85.223.182]:60510 "EHLO
	mail-ie0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932702Ab3E1GuH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 May 2013 02:50:07 -0400
MIME-Version: 1.0
In-Reply-To: <1369412476-14245-5-git-send-email-james.hogan@imgtec.com>
References: <1369412476-14245-1-git-send-email-james.hogan@imgtec.com>
	<1369412476-14245-5-git-send-email-james.hogan@imgtec.com>
Date: Tue, 28 May 2013 08:50:06 +0200
Message-ID: <CACRpkdZEmhDUEk4UjJecCLMzegzwTjCadsP5f+y2QkRB=U6Nvw@mail.gmail.com>
Subject: Re: [PATCH v2 4/9] pinconf-generic: add drive strength to debugfs output
From: Linus Walleij <linus.walleij@linaro.org>
To: James Hogan <james.hogan@imgtec.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 24, 2013 at 6:21 PM, James Hogan <james.hogan@imgtec.com> wrote:

> Add the drive strength pinconf to debugfs output (with the unit "mA").
>
> Signed-off-by: James Hogan <james.hogan@imgtec.com>
> Cc: Linus Walleij <linus.walleij@linaro.org>
> ---
> Changes in v2:
>  - add drive strength to generic pinconf debugfs output (patch 4)

Patch applied for v3.11.

Yours,
Linus Walleij
