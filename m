Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934065Ab3CMRpn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Mar 2013 13:45:43 -0400
Received: from mail-ie0-f180.google.com ([209.85.223.180]:48634 "EHLO
	mail-ie0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933096Ab3CMRpl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Mar 2013 13:45:41 -0400
MIME-Version: 1.0
In-Reply-To: <1363141098-4974-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
References: <1363141098-4974-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Date: Wed, 13 Mar 2013 18:45:40 +0100
Message-ID: <CACRpkdbumRwKh=LBr0R=aj3xF_=gnstS9=mtEn7=4+F85v6tvw@mail.gmail.com>
Subject: Re: [PATCH] pinctrl: Print the correct information in debugfs
 pinconf-state file
From: Linus Walleij <linus.walleij@linaro.org>
To: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 13, 2013 at 3:18 AM, Laurent Pinchart
<laurent.pinchart+renesas@ideasonboard.com> wrote:

> A bad copy&paste resulted in the debugfs pinconf-state file printing the
> pin name instead of the state name. Fix it.
>
> Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>

Applied to my fixes branch.

Yours,
Linus Walleij
