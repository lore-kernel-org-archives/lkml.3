Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754157Ab3C0Dvo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 23:51:44 -0400
Received: from mail-ve0-f172.google.com ([209.85.128.172]:64623 "EHLO
	mail-ve0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750932Ab3C0Dvm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 23:51:42 -0400
MIME-Version: 1.0
In-Reply-To: <20130327144134.0809a21c09b45d20a1fe480d@canb.auug.org.au>
References: <20130327144134.0809a21c09b45d20a1fe480d@canb.auug.org.au>
Date: Wed, 27 Mar 2013 11:51:41 +0800
Message-ID: <CACVXFVPM6qbG2zdDE7apfyKf5mtnEZ2uQNHQTcFNVQ+SPBtbRA@mail.gmail.com>
Subject: Re: linux-next: build failure after merge of the usb tree
From: Ming Lei <tom.leiming@gmail.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Greg KH <greg@kroah.com>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Johan Hovold <jhovold@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wed, Mar 27, 2013 at 11:41 AM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
>
>
> I have reverted the commit from usb.current on the assumption that the
> problem it solves has been, or will be, solved some other way.

The commit is needed in 3.9 linus tree and stable tree,  but for next
tree or 3.10,
a revert commit is required.

We know it is a problem, sorry, :-(


Thanks,
--
Ming Lei
