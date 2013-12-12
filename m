Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751671Ab3LLJw3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Dec 2013 04:52:29 -0500
Received: from mail-ob0-f171.google.com ([209.85.214.171]:39747 "EHLO
	mail-ob0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751120Ab3LLJwX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Dec 2013 04:52:23 -0500
MIME-Version: 1.0
In-Reply-To: <1386789118-24733-2-git-send-email-tj@kernel.org>
References: <1386789118-24733-1-git-send-email-tj@kernel.org>
	<1386789118-24733-2-git-send-email-tj@kernel.org>
Date: Thu, 12 Dec 2013 10:52:22 +0100
Message-ID: <CACRpkdZPzUqmKY9e6jvhCD3WPcrnpBm4p4vvEoghho-7J7RwKQ@mail.gmail.com>
Subject: Re: [PATCH 1/6] kernfs: s/sysfs_dirent/kernfs_node/ and rename its
 friends accordingly
From: Linus Walleij <linus.walleij@linaro.org>
To: Tejun Heo <tj@kernel.org>
Cc: Greg KH <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        NeilBrown <neilb@suse.de>, ashutosh.dixit@intel.com,
        kbuild test robot <fengguang.wu@intel.com>,
        Alexandre Courbot <acourbot@nvidia.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 11, 2013 at 8:11 PM, Tejun Heo <tj@kernel.org> wrote:

> kernfs has just been separated out from sysfs and we're already in
> full conflict mode.  Nothing can make the situation any worse.  Let's
> take the chance to name things properly.
>
> This patch performs the following renames.

Acked-by: Linus Walleij <linus.walleij@linaro.org>

for the gpiolib stuff, FWIW.

Yours,
Linus Walleij
