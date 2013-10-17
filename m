Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751598Ab3JQGNC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Oct 2013 02:13:02 -0400
Received: from mail-qc0-f170.google.com ([209.85.216.170]:53175 "EHLO
	mail-qc0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751074Ab3JQGM6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Oct 2013 02:12:58 -0400
MIME-Version: 1.0
In-Reply-To: <1380987809-4886-1-git-send-email-bcm@fixthebug.org>
References: <1380987809-4886-1-git-send-email-bcm@fixthebug.org>
Date: Wed, 16 Oct 2013 23:12:57 -0700
Message-ID: <CAEPRUYqnc0C_fEG97sFVs6uAtPyZCzXuJ09Hsb3unjAZtc5shA@mail.gmail.com>
Subject: Re: [PATCH v3] ARM: bcm: Add DEBUG_LL console support
From: Christian Daudt <bcm@fixthebug.org>
To: Russell King <linux@arm.linux.org.uk>
Cc: Olof Johansson <olof@lixom.net>, Stephen Warren <swarren@wwwdotorg.org>,
        Chris Ball <cjb@laptop.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        linux-kernel@vger.kernel.org, Christian Daudt <bcm@fixthebug.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 5, 2013 at 8:43 AM, Christian Daudt <bcm@fixthebug.org> wrote:
> This patch adds low level debug uart support to Broadcom
>  mobile based SOCs.
>
> Signed-off-by: Christian Daudt <bcm@fixthebug.org>
>
> Changes from V2:
>  - Changed to follow hex ordering on entries
>  - Dropped defconfig changes
>
> Changes from V1:
>  - Switched to use the common 8250 debug introduced in 3.12-rc1
>

Hi Russell,
 Does V3 look ok ?

 Thanks,
   csd
