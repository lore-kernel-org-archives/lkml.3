Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756506AbbAFTPe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 14:15:34 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:53062 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753405AbbAFTPd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 14:15:33 -0500
Date: Tue, 06 Jan 2015 14:15:31 -0500 (EST)
Message-Id: <20150106.141531.1937050067918707190.davem@davemloft.net>
To: skhare@vmware.com
Cc: sbhatewara@vmware.com, pv-drivers@vmware.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, bollar@vmware.com
Subject: Re: [PATCH net-next] Driver: Vmxnet3: Make Rx ring 2 size
 configurable
From: David Miller <davem@davemloft.net>
In-Reply-To: <1420564815-32101-1-git-send-email-skhare@vmware.com>
References: <1420564815-32101-1-git-send-email-skhare@vmware.com>
X-Mailer: Mew version 6.6 on Emacs 24.4 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Tue, 06 Jan 2015 11:15:33 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Shrikrishna Khare <skhare@vmware.com>
Date: Tue,  6 Jan 2015 09:20:15 -0800

> Rx ring 2 size can be configured by adjusting rx-jumbo parameter
> of ethtool -G.
> 
> Signed-off-by: Ramya Bolla <bollar@vmware.com>
> Signed-off-by: Shreyas Bhatewara <sbhatewara@vmware.com>
> Signed-off-by: Shrikrishna Khare <skhare@vmware.com>

Applied, thanks.
