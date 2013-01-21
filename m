Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756762Ab3AUXpP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 18:45:15 -0500
Received: from mail-ie0-f170.google.com ([209.85.223.170]:35603 "EHLO
	mail-ie0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756418Ab3AUXpM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 18:45:12 -0500
MIME-Version: 1.0
In-Reply-To: <20130119110328.GO4584@mwanda>
References: <1358541648-29922-1-git-send-email-mark.einon@gmail.com>
 <20130118225706.GA22140@kroah.com> <20130119110328.GO4584@mwanda>
From: Mark Einon <mark.einon@gmail.com>
Date: Mon, 21 Jan 2013 23:44:55 +0000
Message-ID: <CANK3SE2p3C38YrvCxWqvoRRz7=q7oAYyE=b0c7+ppBd3yzVrpw@mail.gmail.com>
Subject: Re: [RFC PATCH linux-next] et131x: Promote staging et131x driver to drivers/net
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Greg KH <gregkh@linuxfoundation.org>, devel@driverdev.osuosl.org,
        sfr@canb.auug.org.au, davem@davemloft.net,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 19 January 2013 11:03, Dan Carpenter <dan.carpenter@oracle.com> wrote:
<snip>
>
> et131x_get_regs() has endian bugs calling et131x_mii_read().
>
</snip>

Hi Dan,

Could you be a bit more descriptive about the issues you think there
are with these calls?

cheers,

Mark
