Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751341Ab3ASGCN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jan 2013 01:02:13 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:47484 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750986Ab3ASGCM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jan 2013 01:02:12 -0500
Date: Sat, 19 Jan 2013 06:02:10 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Cong Ding <dinggnu@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fs: timerfd.c: fix build error
Message-ID: <20130119060210.GL4939@ZenIV.linux.org.uk>
References: <1358545972-20947-1-git-send-email-dinggnu@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1358545972-20947-1-git-send-email-dinggnu@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 18, 2013 at 10:52:52PM +0100, Cong Ding wrote:
> Invalid number of parentheses if macro COMPAT is defined

Thanks; folded.
