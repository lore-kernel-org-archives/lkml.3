Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932395AbaHGP5W (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2014 11:57:22 -0400
Received: from asavdk3.altibox.net ([109.247.116.14]:58829 "EHLO
	asavdk3.altibox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757488AbaHGP5V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2014 11:57:21 -0400
Date: Thu, 7 Aug 2014 17:57:14 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Shuah Khan <shuah.kh@samsung.com>
Cc: mmarek@suse.cz, gregkh@linuxfoundation.org, linux-kbuild@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] kbuild: kselftest - new make target to build and run
 kernel selftests
Message-ID: <20140807155713.GA1382@ravnborg.org>
References: <1407420192-4928-1-git-send-email-shuah.kh@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1407420192-4928-1-git-send-email-shuah.kh@samsung.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 07, 2014 at 08:03:12AM -0600, Shuah Khan wrote:
> Add a new make target "kselftest" to enable kernel testing. This
> new target builds and runs kernel selftests. Running as root is
> recommended for a complete test run as some tests don't run when
> run by non-root user.

kselftest will run the test - but will not build the kerenl.
That is does not build the kernel is IMO a good thing -
as one may re-run the test while doing work on the kernel, and triggering
a rebuild to re-run the test is not nice.

The changelog + help text needs to be updated to reflect that the kernel is not
built when you use "make kselftest".

On top of this - can you please tell what plans exists to extend this.
When we discussed "devtest" it was said that it would not be a wrapper
for selftests run_tests only, but more was planned to be added.


	Sam
