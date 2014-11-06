Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751465AbaKFUNq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 15:13:46 -0500
Received: from tex.lwn.net ([70.33.254.29]:50657 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750963AbaKFUNn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 15:13:43 -0500
Date: Thu, 6 Nov 2014 15:13:41 -0500
From: Jonathan Corbet <corbet@lwn.net>
To: Fabian Frederick <fabf@skynet.be>
Cc: linux-kernel@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        linux-doc@vger.kernel.org
Subject: Re: [PATCH V2 linux-next] ipv4: add kernel parameter
 tcpmhash_entries
Message-ID: <20141106151341.61d43317@lwn.net>
In-Reply-To: <1415299611-5373-1-git-send-email-fabf@skynet.be>
References: <1415299611-5373-1-git-send-email-fabf@skynet.be>
Organization: LWN.net
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu,  6 Nov 2014 19:46:50 +0100
Fabian Frederick <fabf@skynet.be> wrote:

> This patch also adds a reference to ip-sysctl.txt
> where TCP metrics setup is described

Applied to the docs tree, thanks.

jon
