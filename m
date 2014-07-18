Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946136AbaGRVGp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 17:06:45 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:45790 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946095AbaGRVGn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 17:06:43 -0400
Date: Fri, 18 Jul 2014 14:06:42 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Shuah Khan <shuah.kh@samsung.com>
Cc: mmarek@suse.cz, linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kbuild: devtest - new make target for build all and run
 tests
Message-ID: <20140718210642.GA11185@kroah.com>
References: <1405716274-24420-1-git-send-email-shuah.kh@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1405716274-24420-1-git-send-email-shuah.kh@samsung.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 18, 2014 at 02:44:34PM -0600, Shuah Khan wrote:
> Add a new devtest make target to enable developer testing. This
> new target does full build (make all) and then runs selftests.
> 
> Signed-off-by: Shuah Khan <shuah.kh@samsung.com>

Nice to see this.

Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
