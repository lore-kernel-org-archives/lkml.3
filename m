Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751507Ab3JTMf2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Oct 2013 08:35:28 -0400
Received: from imap.thunk.org ([74.207.234.97]:48187 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751305Ab3JTMf1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Oct 2013 08:35:27 -0400
Date: Sun, 20 Oct 2013 08:35:21 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: jiaweiwei <jiaweiwei.xiyou@gmail.com>
Cc: Vyacheslav Dubeyko <slava@dubeyko.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Harry Wei <harryxiyou@gmail.com>
Subject: Re: [RFC] Rollback FS
Message-ID: <20131020123521.GA15627@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	jiaweiwei <jiaweiwei.xiyou@gmail.com>,
	Vyacheslav Dubeyko <slava@dubeyko.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	Harry Wei <harryxiyou@gmail.com>
References: <CABjrhvqTHkuEyQ=-xaud5Y0i3YqYcdBsm2eWrR-44V=OESWypg@mail.gmail.com>
 <F713E780-33E1-494C-ADAD-92211724209E@dubeyko.com>
 <CABjrhvqLgVSEOJVuS1n-R_kyvhFouUqhfjqS4P_jsPGAec+KdQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABjrhvqLgVSEOJVuS1n-R_kyvhFouUqhfjqS4P_jsPGAec+KdQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 20, 2013 at 07:37:01PM +0800, jiaweiwei wrote:
> 
> Any file system should rollback but not specific ones. Therefore, a
> VFS like mechanism should be designed and implemented.

And what if the blocks or inodes used for the files that were deleted
have already been used and overwritten?

> Maybe, I would give detail design, thanks.

I encourage you to try to do that; you might find it to be an
educational exercise.

Best regards,

					- Ted
