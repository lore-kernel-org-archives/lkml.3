Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752560AbaHACkA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 22:40:00 -0400
Received: from g4t3426.houston.hp.com ([15.201.208.54]:46235 "EHLO
	g4t3426.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751316AbaHACj7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 22:39:59 -0400
Message-ID: <1406860795.3036.3.camel@buesod1.americas.hpqcorp.net>
Subject: Re: [REVIEW][PATCH 0/4] /proc/thread-self
From: Davidlohr Bueso <davidlohr@hp.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Linux Containers <containers@lists.linux-foundation.org>,
        linux-api@vger.kernel.org,
        "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Thu, 31 Jul 2014 19:39:55 -0700
In-Reply-To: <87oaw5caq1.fsf@x220.int.ebiederm.org>
References: <87oaw5caq1.fsf@x220.int.ebiederm.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-07-31 at 17:30 -0700, Eric W. Biederman wrote:
> This is small chance changing /proc/net and /proc/mounts will cause
> userspace regressions (although nothing has shown up in my testing) if
> that happens we can just point the change that moves them from
> /proc/self/... to /proc/thread-self/...

Isn't breaking userspace a no no, no matter what? At least some
util-linux programs makes use of both /proc/mounts and /proc/net.

