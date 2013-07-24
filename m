Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754592Ab3GXQ1z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 12:27:55 -0400
Received: from mail-ve0-f181.google.com ([209.85.128.181]:61475 "EHLO
	mail-ve0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753665Ab3GXQ1y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 12:27:54 -0400
MIME-Version: 1.0
In-Reply-To: <20130721190212.GA31470@pd.tnic>
References: <20130721144819.GJ24717@sanechka.spb.ru>
	<20130721190212.GA31470@pd.tnic>
Date: Wed, 24 Jul 2013 09:27:53 -0700
Message-ID: <CA+8MBb+GzRkj9M7gy9g5CvXfzMGCYXRXfTUycbojnspyrwvTeQ@mail.gmail.com>
Subject: Re: lockdep warning in edac_create_sysfs_mci_device
From: Tony Luck <tony.luck@gmail.com>
To: Borislav Petkov <bp@alien8.de>
Cc: "Alexandra N. Kossovsky" <Alexandra.Kossovsky@oktetlabs.ru>,
        Doug Thompson <dougthompson@xmission.com>,
        Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 21, 2013 at 12:02 PM, Borislav Petkov <bp@alien8.de> wrote:
> A fix is on the way:
>
> http://marc.info/?l=linux-edac&m=137422971614927&w=2

Fix was pulled into Linus' tree yesterday evening (Portland, OR timezone):

commit 88d84ac97378c2f1d5fec9af1e8b7d9a662d6b00
Author: Borislav Petkov <bp@suse.de>
Date:   Fri Jul 19 12:28:25 2013 +0200

    EDAC: Fix lockdep splat

Alexandra: Give it a test and let me and Boris know if you still see
any problems.

-Tony
