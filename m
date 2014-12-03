Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752887AbaLCL4m (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 06:56:42 -0500
Received: from ozlabs.org ([103.22.144.67]:54788 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752470AbaLCL4j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 06:56:39 -0500
Message-ID: <1417607797.23663.1.camel@concordia>
Subject: Re: linux-next: manual merge of the kselftest tree with the
 kselftest-fixes tree
From: Michael Ellerman <mpe@ellerman.id.au>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Shuah Khan <shuahkh@osg.samsung.com>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Wed, 03 Dec 2014 22:56:37 +1100
In-Reply-To: <20141203203210.2eef1e6c@canb.auug.org.au>
References: <20141203203210.2eef1e6c@canb.auug.org.au>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4-0ubuntu2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-12-03 at 20:32 +1100, Stephen Rothwell wrote:
> Hi Shuah,
> 
> Today's linux-next merge of the kselftest tree got a cselftests/kcmp:
> Always try to build the testonflict in
> tools/testing/selftests/kcmp/Makefile between commit 4c12df63f7ff ("")
> from the kselftest-fixes tree and commit c0d8a9393efd
> ("selftests/kcmp: add install target to enable installing test") from
> the kselftest tree.

That got a bit mixed up, I think it should be:

  Today's linux-next merge of the kselftest tree got a conflict in
  tools/testing/selftests/kcmp/Makefile between commit 4c12df63f7ff
  ("selftests/kcmp: Always try to build the test") from the kselftest-fixes
  tree and commit c0d8a9393efd ("selftests/kcmp: add install target to enable
  installing test") from the kselftest tree.

> I fixed it up (see below - probably some more could be done) and can
> carry the fix as necessary (no action is required).

That resolution basically negates the effect of the first patch.

Shuah, seeing these are both your trees are you happy to do the proper
resolution?

cheers



