Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753859Ab3IESBn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Sep 2013 14:01:43 -0400
Received: from eddie.linux-mips.org ([78.24.191.182]:37494 "EHLO
	cvs.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753214Ab3IESBm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Sep 2013 14:01:42 -0400
Date: Thu, 5 Sep 2013 20:01:36 +0200
From: Ralf Baechle <ralf@linux-mips.org>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: linux-mips@linux-mips.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] MIPS: Export copy_from_user_page() (needed by lustre)
Message-ID: <20130905180136.GA11592@linux-mips.org>
References: <1378372965-27213-1-git-send-email-geert@linux-m68k.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1378372965-27213-1-git-send-email-geert@linux-m68k.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 05, 2013 at 11:22:45AM +0200, Geert Uytterhoeven wrote:

> ERROR: "copy_from_user_page" [drivers/staging/lustre/lustre/libcfs/libcfs.ko] undefined!

Thanks, applied!

But I'm sort surprised to see somebody testing Lustre on MIPS :-)

  Ralf
