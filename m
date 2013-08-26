Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754043Ab3HZRVB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Aug 2013 13:21:01 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:46294 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752310Ab3HZRVA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Aug 2013 13:21:00 -0400
Date: Mon, 26 Aug 2013 18:20:55 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Djalal Harouni <tixxdz@opendz.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com
Subject: Re: [PATCH 1/2] procfs: restore 0400 permissions on
 /proc/*/{syscall,stack,personality}
Message-ID: <20130826172054.GE27005@ZenIV.linux.org.uk>
References: <1377534240-13227-1-git-send-email-tixxdz@opendz.org>
 <871u5gqtw3.fsf@xmission.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <871u5gqtw3.fsf@xmission.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 26, 2013 at 09:49:48AM -0700, Eric W. Biederman wrote:

> How does changing the permissions to S_IRUSR prevent someone from
> opening the file before, and reading the file after a suid exec?
> 
> > This patch restores the old mode which was 0400
> 
> Which seems to add no security whatsoever and obscure the fact that
> anyone who cares can read the file so what is the point?

Two words: "security sclerosis".  Both patches NAKed, of course.
