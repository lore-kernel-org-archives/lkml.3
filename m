Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751595AbaIUVMp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Sep 2014 17:12:45 -0400
Received: from mail-qa0-f51.google.com ([209.85.216.51]:43241 "EHLO
	mail-qa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751313AbaIUVMo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Sep 2014 17:12:44 -0400
Date: Sun, 21 Sep 2014 17:12:40 -0400
From: Tejun Heo <tj@kernel.org>
To: Guenter Roeck <linux@roeck-us.net>
Cc: linux-kernel@vger.kernel.org,
        Waldemar Brodkorb <mail@waldemar-brodkorb.de>,
        Jesper Nilsson <jespern@axis.com>, Mikael Starvik <starvik@axis.com>,
        linux-cris-kernel@axis.com
Subject: Re: [RFC PATCH 8/8] Revert "percpu: free percpu allocation info for
 uniprocessor system"
Message-ID: <20140921211240.GB996@mtj.dyndns.org>
References: <1411316838-15135-1-git-send-email-linux@roeck-us.net>
 <1411316838-15135-9-git-send-email-linux@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1411316838-15135-9-git-send-email-linux@roeck-us.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Sun, Sep 21, 2014 at 09:27:18AM -0700, Guenter Roeck wrote:
> This reverts commit 3189eddbcafcc4d827f7f19facbeddec4424eba8.

Please use 12-DIGIT-PREFIX-OF-SHA1 ("PATCH_TITLE") format.

> The commit causes a hang with a crisv32 image. This may be an architecture
> problem, but at least for now the revert is necessary to be able to boot a
> crisv32 image.
> 
> Signed-off-by: Guenter Roeck <linux@roeck-us.net>

Please repost with the original patch author and me cc'd.

Thanks!

-- 
tejun
