Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756764Ab3APUzb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 15:55:31 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:39016 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753390Ab3APUza (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 15:55:30 -0500
Date: Wed, 16 Jan 2013 15:55:27 -0500 (EST)
Message-Id: <20130116.155527.1163555891632434773.davem@davemloft.net>
To: tushar.behera@linaro.org
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, gregkh@linuxfoundation.org, jacmet@sunsite.dk,
        patches@linaro.org, ming.lei@canonical.com
Subject: Re: [PATCH] usbnet: dm9601: Fix incorrect command
From: David Miller <davem@davemloft.net>
In-Reply-To: <1358228341-2104-1-git-send-email-tushar.behera@linaro.org>
References: <1358228341-2104-1-git-send-email-tushar.behera@linaro.org>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tushar Behera <tushar.behera@linaro.org>
Date: Tue, 15 Jan 2013 11:09:01 +0530

> commit 24b1042c4eb2 ("usbnet: dm9601: apply introduced usb command
> APIs") removes the distiction between DM_WRITE_REG and DM_WRITE_REGS
> command. The distiction is reintroduced to the driver so that the
> functionality of the driver remains same.
> 
> CC: Ming Lei <ming.lei@canonical.com>
> Signed-off-by: Tushar Behera <tushar.behera@linaro.org>

Applied, thanks.
