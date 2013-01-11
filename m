Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755347Ab3AKSoy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2013 13:44:54 -0500
Received: from mail-vc0-f179.google.com ([209.85.220.179]:56239 "EHLO
	mail-vc0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754776Ab3AKSow (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2013 13:44:52 -0500
MIME-Version: 1.0
In-Reply-To: <20130111105440.3497d6f8c79189ff6a1bd236@canb.auug.org.au>
References: <20130111105440.3497d6f8c79189ff6a1bd236@canb.auug.org.au>
Date: Fri, 11 Jan 2013 10:44:51 -0800
Message-ID: <CA+8MBbKZ7tiiTTM6Dwqaqg3MK6mSMAiYOmLUJhGc8m1F5vrfiw@mail.gmail.com>
Subject: Re: linux-next: build failure after merge of the ia64 tree
From: Tony Luck <tony.luck@gmail.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Seiji Aguchi <seiji.aguchi@hds.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 10, 2013 at 3:54 PM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> ERROR: "pstore_cannot_block_path" [drivers/firmware/efivars.ko] undefined!

Should be fixed today (allmodconfig builds for me).  I applied Seiji's
new version
of the patchset that included the missing EXPORT_SYMBOL_GPL.

-Tony
