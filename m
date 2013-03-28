Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753268Ab3C1VQl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Mar 2013 17:16:41 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:56596 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752768Ab3C1VQj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Mar 2013 17:16:39 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Tony Prisk <linux@prisktech.co.nz>
Subject: Re: [PATCH] usb: ehci: mark unlink_empty_async_suspended() as __maybe_unused
Date: Thu, 28 Mar 2013 21:16:21 +0000
User-Agent: KMail/1.12.2 (Linux/3.8.0-13-generic; KDE/4.3.2; x86_64; ; )
Cc: "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, stern@rowland.harvard.edu
References: <1364362080-8489-1-git-send-email-linux@prisktech.co.nz> <201303282109.47130.arnd@arndb.de>
In-Reply-To: <201303282109.47130.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201303282116.21727.arnd@arndb.de>
X-Provags-ID: V02:K0:HQmZNeywKhxaSYSmZRz69Jv36xwzXLgx4xD00AVs9T4
 L+xrtUUPCFH5IGorUYgAp5FUDoMPUKguRQTeHtLiWfYzELjTO8
 ZrHPatujUFEn8xuxWvadO90ZLsOGURvzoWUNmCTZYkuDeb8Yoy
 +T+aKtpBP6mVCk1EVpTfyelsi4QhluDW+SPX+79GS6aFQk07qA
 vzljAjaxz/MuBnJl+275pj1mQd33/Mjrs0lZCEMxy7dRq7ZQjV
 gV9Cnqb2lJYHqchQT48rcMVjq+tuiV21Sp55JNY+aRVbdYEDaB
 Zo5sy59xwcLifTKqc5Y1qGXReDMEESNco4mdHKrsnaM7qd/Ldy
 aVcHDW2wmhQYIbwFvoh8=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 28 March 2013, Arnd Bergmann wrote:
> Patch 4d053fdac3 "usb: ehci: unlink_empty_async_suspended() only used
> with CONFIG_PM" tried to hide the unlink_empty_async_suspended function
> inside of an #ifdef to work around an unused function warning.

Hi Greg,

Apparently the warning is now also in 3.8.5, so you might want to backport
this fix as well after you send it upstream.

	Arnd
