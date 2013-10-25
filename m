Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754765Ab3JYT7r (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Oct 2013 15:59:47 -0400
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:46083 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753020Ab3JYT7q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Oct 2013 15:59:46 -0400
Date: Fri, 25 Oct 2013 21:59:43 +0200
From: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
To: Cong Ding <dinggnu@gmail.com>
Cc: "Hans J. Koch" <hjk@hansjkoch.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] uio: fix memory leak
Message-ID: <20131025195943.GB16436@breakpoint.cc>
References: <1382685953-19413-1-git-send-email-dinggnu@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1382685953-19413-1-git-send-email-dinggnu@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 25.10.13, Cong Ding wrote:
> we have to call kobject_put() to clean up the kobject after function
> kobject_init(), kobject_add(), or kobject_uevent() is called.
> 
> Signed-off-by: Cong Ding <dinggnu@gmail.com>
Acked-by: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>

Sebastian
