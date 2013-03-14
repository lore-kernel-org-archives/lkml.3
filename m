Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753496Ab3CNW0m (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 18:26:42 -0400
Received: from www.linutronix.de ([62.245.132.108]:54840 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753278Ab3CNW0l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 18:26:41 -0400
Date: Thu, 14 Mar 2013 23:26:39 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Arnd Bergmann <arnd@arndb.de>
cc: linux-arm-kernel@vger.kernel.org, patches@linaro.org,
        Olof Johansson <olof@lixom.net>, linux-kernel@vger.kernel.org,
        Robert Schwebel <r.schwebel@pengutronix.de>,
        Sascha Hauer <s.hauer@pengutronix.de>
Subject: Re: [PATCH 5/6] ARM: kill Hynix h720x platform
In-Reply-To: <1363299128-8192-6-git-send-email-arnd@arndb.de>
Message-ID: <alpine.LFD.2.02.1303142326090.22263@ionos>
References: <1363299128-8192-1-git-send-email-arnd@arndb.de> <1363299128-8192-6-git-send-email-arnd@arndb.de>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 14 Mar 2013, Arnd Bergmann wrote:

> The platform was merged about 10 years ago, and has seen few updates
> for most of the time since. The people that merged the code seem
> no longer interested in it either, so let's remove it now.
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

Acked-by: Thomas Gleixner <tglx@linutronix.de>

