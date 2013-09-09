Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755286Ab3IIQbc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 12:31:32 -0400
Received: from kanga.kvack.org ([205.233.56.17]:46667 "EHLO kanga.kvack.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753742Ab3IIQbb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 12:31:31 -0400
Date: Mon, 9 Sep 2013 12:31:30 -0400
From: Benjamin LaHaise <bcrl@kvack.org>
To: Artem Savkov <artem.savkov@gmail.com>
Cc: viro@zeniv.linux.org.uk, linux-aio@kvack.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] aio: rcu_read_lock protection for new rcu_dereference calls
Message-ID: <20130909163130.GB11250@kvack.org>
References: <1378649444-28054-1-git-send-email-artem.savkov@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1378649444-28054-1-git-send-email-artem.savkov@gmail.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 08, 2013 at 06:10:43PM +0400, Artem Savkov wrote:
> Patch "aio: fix rcu sparse warnings introduced by ioctx table lookup patch"
> (77d30b14d24e557f89c41980011d72428514d729 in linux-next.git) introduced a
> couple of new rcu_dereference calls which are not protected by rcu_read_lock
> and result in following warnings during syscall fuzzing(trinity):

Applied.  Thanks Artem.

		-ben
-- 
"Thought is the essence of where you are now."
