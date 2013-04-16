Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964943Ab3DPPps (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Apr 2013 11:45:48 -0400
Received: from smtp-out-032.synserver.de ([212.40.185.32]:1084 "EHLO
	smtp-out-032.synserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751841Ab3DPPpr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Apr 2013 11:45:47 -0400
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 7208
Message-ID: <516D71F7.3020006@metafoo.de>
Date: Tue, 16 Apr 2013 17:44:55 +0200
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.12) Gecko/20130116 Icedove/10.0.12
MIME-Version: 1.0
To: "Opensource [Anthony Olech]" <anthony.olech.opensource@diasemi.com>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [NEW DRIVER V4 2/7] DA9058 ADC driver
References: <201304121320.r3CDKLNL013219@latitude> <51683294.40908@metafoo.de> <24DF37198A1E704D9811D8F72B87EB514191E442@NB-EX-MBX02.diasemi.com>
In-Reply-To: <24DF37198A1E704D9811D8F72B87EB514191E442@NB-EX-MBX02.diasemi.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/16/2013 04:22 PM, Opensource [Anthony Olech] wrote:
>> [...]
>> please always test your drivers against the latest upstream version before submitting them.
>> [...]
> 
> Hi Lars,
> 
> The driver was tested against linux mainline tag v3.9-rc6, because that was the most recent
> tagged commit in git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git on the day
> that I sent in the patches.
> 
> What exactly do you mean by "latest upstream version" ?
> Did I use the correct repository ?

So, there are usually subsystem specific trees. You can usually find them in
the MAINTAINERS file. E.g. for the IIO subsystem it is
git://git.kernel.org/pub/scm/linux/kernel/git/jic23/iio.git
The subsystem trees can be up to 3 months (one release) ahead of Linus'
tree. If in doubt place your changes ontop of the next tree, which should
have all the changes from the subsystem trees.

- Lars
