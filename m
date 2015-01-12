Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752756AbbALVoq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 16:44:46 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:54322 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752519AbbALVop (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 16:44:45 -0500
Date: Mon, 12 Jan 2015 16:44:43 -0500 (EST)
Message-Id: <20150112.164443.1375211702342773207.davem@davemloft.net>
To: skhare@vmware.com
Cc: sbhatewara@vmware.com, pv-drivers@vmware.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, smurali@vmware.com
Subject: Re: [PATCH net-next] Driver: Vmxnet3: Reinitialize vmxnet3 backend
 on wakeup from hibernate
From: David Miller <davem@davemloft.net>
In-Reply-To: <1420845554-491-1-git-send-email-skhare@vmware.com>
References: <1420845554-491-1-git-send-email-skhare@vmware.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Mon, 12 Jan 2015 13:44:44 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Shrikrishna Khare <skhare@vmware.com>
Date: Fri,  9 Jan 2015 15:19:14 -0800

> Failing to reinitialize on wakeup results in loss of network connectivity for
> vmxnet3 interface.
> 
> Signed-off-by: Srividya Murali <smurali@vmware.com>
> Signed-off-by: Shrikrishna Khare <skhare@vmware.com>
> Reviewed-by: Shreyas N Bhatewara <sbhatewara@vmware.com>

Applied, thanks.
