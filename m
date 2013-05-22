Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754641Ab3EVNAW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 May 2013 09:00:22 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:51143 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755132Ab3EVM7m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 May 2013 08:59:42 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Huang Shijie <b32955@freescale.com>
Subject: Re: [PATCH 1/6] drivers: bus: add a new driver for WEIM
Date: Wed, 22 May 2013 14:59:34 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: Shawn Guo <shawn.guo@linaro.org>, grant.likely@linaro.org,
        rob.herring@calxeda.com, devicetree-discuss@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
References: <1369039742-10893-1-git-send-email-b32955@freescale.com> <20130521054323.GE3080@S2101-09.ap.freescale.net> <519C7ED3.3030004@freescale.com>
In-Reply-To: <519C7ED3.3030004@freescale.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <201305221459.34859.arnd@arndb.de>
X-Provags-ID: V02:K0:1iJ41iGXqG6KD/iVatbDjIr3aWvnl8c0/s9Tcd8q5ip
 GhlEbNd8QQyHOuqBYQhhSTJF4qxGE7ItFu+KEkXVqZMjG5yQtp
 P0IAwpm0RfXlKCKw0vIdZR7eHggSjThB0kjVGZJrZDxShxqGcS
 Xk28njBMBuaDmp8WCGSfItPVi0OiB5PqANo7QRPfzJAO9laKyW
 GvGM3+mFeMF+Xc3mR1rmBNFS6vAiYDdvDM23S4BzIQwSQHC3pe
 w7ByPJSkPMiBJmupHNBwfmTtqn9cIcHFFD292DoBxQHyhlryJQ
 uXyltOasi0WNWOAxAB5aoowTHvUYqfDhVod4E+y0Gkk0CaNjdA
 XHHzhoO8UnFhRQQKZxkQ=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 22 May 2013, Huang Shijie wrote:
> 于 2013年05月21日 13:43, Shawn Guo 写道:
> > It seems we can find it out from "reg" property, so that we can save
> > this property?
> >
> we may have several devices attaching to the weim, each device has its 
> own CS index.
> it's better to keep this property, make it more clear.

I agree with Shawn, we should not have this property when it is the
same as the upper half of the "reg" property.

	Arnd
