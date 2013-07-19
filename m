Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965531Ab3GSFZB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jul 2013 01:25:01 -0400
Received: from mx1.redhat.com ([209.132.183.28]:22620 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965446Ab3GSFY7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jul 2013 01:24:59 -0400
Date: Fri, 19 Jul 2013 10:54:49 +0530
From: Amit Shah <amit.shah@redhat.com>
To: Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>
Cc: linux-kernel@vger.kernel.org,
        Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Arnd Bergmann <arnd@arndb.de>, yrl.pp-manager.tt@hitachi.com,
        Virtualization List <virtualization@lists.linux-foundation.org>
Subject: Re: [PATCH 0/2] [BUGFIX] virtio/console: Fix two bugs of splice_write
Message-ID: <20130719052449.GE3087@amit-x200.redhat.com>
References: <20130718231927.3664.50418.stgit@yunodevel>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130718231927.3664.50418.stgit@yunodevel>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On (Fri) 19 Jul 2013 [08:19:27], Yoshihiro YUNOMAE wrote:
> Hi,
> 
> This patch set fixes two bugs of splice_write in the virtio-console driver.

Oh, and please CC virtualization@lists.linux-foundation.org for any
virtio-related patches.

Thanks,

		Amit
