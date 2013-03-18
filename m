Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753421Ab3CRO5U (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 10:57:20 -0400
Received: from mail-vc0-f173.google.com ([209.85.220.173]:53646 "EHLO
	mail-vc0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751860Ab3CRO5S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 10:57:18 -0400
Date: Mon, 18 Mar 2013 11:57:11 -0300
From: Gustavo Padovan <gustavo@padovan.org>
To: Alexandru Gheorghiu <gheorghiuandru@gmail.com>
Cc: Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: bluetooth: Use PTR_RET function
Message-ID: <20130318145711.GB16337@joana>
Mail-Followup-To: Gustavo Padovan <gustavo@padovan.org>,
	Alexandru Gheorghiu <gheorghiuandru@gmail.com>,
	Marcel Holtmann <marcel@holtmann.org>,
	Johan Hedberg <johan.hedberg@gmail.com>,
	linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1363443003-13839-1-git-send-email-gheorghiuandru@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1363443003-13839-1-git-send-email-gheorghiuandru@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alexandru,

* Alexandru Gheorghiu <gheorghiuandru@gmail.com> [2013-03-16 16:10:03 +0200]:

> Used PTR_RET function instead of IS_ERR and PTR_ERR.
> Patch found using coccinelle.
> 
> Signed-off-by: Alexandru Gheorghiu <gheorghiuandru@gmail.com>
> ---
>  net/bluetooth/hci_sysfs.c |    4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)

Patch has been applied to bluetooth-next. Thanks.

	Gustavo
