Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756153Ab3LUVG3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Dec 2013 16:06:29 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:32797 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756041Ab3LUVG1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Dec 2013 16:06:27 -0500
Date: Sat, 21 Dec 2013 13:06:38 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Ravi Patel <rapatel@apm.com>
Cc: arnd@arndb.de, davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, jcm@redhat.com, patches@apm.com,
        Keyur Chudgar <kchudgar@apm.com>
Subject: Re: [PATCH V2 0/4] misc: xgene: Add support for APM X-Gene SoC Queue
 Manager/Traffic Manager
Message-ID: <20131221210638.GA30102@kroah.com>
References: <1387594651-25771-1-git-send-email-rapatel@apm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1387594651-25771-1-git-send-email-rapatel@apm.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 20, 2013 at 06:57:27PM -0800, Ravi Patel wrote:
> This patch adds support for APM X-Gene SoC Queue Manager/Traffic Manager.
>  QMTM is required by APM X-Gene SoC Ethernet, PktDMA (XOR Engine) and
>  Security Engine subsystems. All subsystems communicate with QMTM using
>  messages which include information about the work to be performed and
>  the location of associated data buffers.  

As you failed to respond or even acknowledge any of my review comments
before, I don't understand what you expect me to do with this patch dump
again.

Remember, kernel development is about trust.  You need me to trust that
you know what you are doing, and will be able to handle feedback and
respond to issues that come up over time.  Right now that trust is in
the negative zone, around "general annoyance" levels.  It's up to you to
change that or not, just like it is up to me to take your code, or not.

grumble,

greg k-h
