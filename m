Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751926AbaAJHLt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jan 2014 02:11:49 -0500
Received: from qproxy1-pub.mail.unifiedlayer.com ([173.254.64.10]:50784 "HELO
	qproxy1.mail.unifiedlayer.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with SMTP id S1750793AbaAJHLq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jan 2014 02:11:46 -0500
Message-ID: <1389337893.3938.3.camel@slavad-ubuntu>
Subject: Re: hfsplus: kernel panic in hfsplus_brec_lenoff
From: Vyacheslav Dubeyko <slava@dubeyko.com>
Reply-To: slava@dubeyko.com
To: Sasha Levin <sasha.levin@oracle.com>
Cc: linux-fsdevel@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Kent Overstreet <kmo@daterainc.com>, Al Viro <viro@ZenIV.linux.org.uk>
Date: Fri, 10 Jan 2014 11:11:33 +0400
In-Reply-To: <52CF2CEC.3010003@oracle.com>
References: <52CF2CEC.3010003@oracle.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Identified-User: {2172:host202.hostmonster.com:dubeykoc:dubeyko.com} {sentby:smtp auth 109.188.127.157 authed with slava@dubeyko.com}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-01-09 at 18:12 -0500, Sasha Levin wrote:
> Hi all,
> 
> While fuzzing with trinity inside a KVM tools guest running latest -next kernel
> I've stumbled on the following spew:
> 
> [ 5835.181300] BUG: unable to handle kernel paging request at ffff880055a3cffa


Thank you for report about the issue.

But could you share a reproducing path? Or, maybe, is it possible to
repeat your steps?

It will be great to have reproducing path.

Thanks,
Vyacheslav Dubeyko.


