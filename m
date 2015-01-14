Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752292AbbANCQB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 21:16:01 -0500
Received: from ozlabs.org ([103.22.144.67]:55619 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751004AbbANCQA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 21:16:00 -0500
Message-ID: <1421201759.10748.8.camel@ellerman.id.au>
Subject: Re: [PATCH] selftests/powerpc: Add .gitignore for powerpc selftests
From: Michael Ellerman <mpe@ellerman.id.au>
To: Shuah Khan <shuahkh@osg.samsung.com>
Cc: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
Date: Wed, 14 Jan 2015 13:15:59 +1100
In-Reply-To: <54B5B561.40406@osg.samsung.com>
References: <1421192997-17003-1-git-send-email-mpe@ellerman.id.au>
	 <54B5B561.40406@osg.samsung.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.7-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2015-01-13 at 17:16 -0700, Shuah Khan wrote:
> Please add a commit log.
 
What does it need to say?

> On 01/13/2015 04:49 PM, Michael Ellerman wrote:
> > Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
> > ---
> >  .../testing/selftests/powerpc/copyloops/.gitignore |  4 ++++
> >  tools/testing/selftests/powerpc/mm/.gitignore      |  1 +
> >  tools/testing/selftests/powerpc/pmu/.gitignore     |  3 +++
> >  tools/testing/selftests/powerpc/pmu/ebb/.gitignore | 22 ++++++++++++++++++++++
> >  .../selftests/powerpc/primitives/.gitignore        |  1 +
> >  tools/testing/selftests/powerpc/tm/.gitignore      |  1 +
> >  6 files changed, 32 insertions(+)
> >  create mode 100644 tools/testing/selftests/powerpc/copyloops/.gitignore
> >  create mode 100644 tools/testing/selftests/powerpc/mm/.gitignore
> >  create mode 100644 tools/testing/selftests/powerpc/pmu/.gitignore
> >  create mode 100644 tools/testing/selftests/powerpc/pmu/ebb/.gitignore
> >  create mode 100644 tools/testing/selftests/powerpc/primitives/.gitignore
> >  create mode 100644 tools/testing/selftests/powerpc/tm/.gitignore
> 
> Please create a single .gitignore for all targets right under
> tools/testing/selftests/powerpc instead of multiple .gitignore
> files.

Why? Having separate files makes it less likely we'll get merge conflicts
between different test subdirectores, it also makes it more likely someone
adding a test will notice they need to update the .gitignore in the same
directory.

cheers


