Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751652Ab3FZHVH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 03:21:07 -0400
Received: from mail-la0-f50.google.com ([209.85.215.50]:46443 "EHLO
	mail-la0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750886Ab3FZHVF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 03:21:05 -0400
Date: Wed, 26 Jun 2013 11:21:02 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Oleg Nesterov <oleg@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] proc: Expose /proc/<pid>/task/<tid>/children
 unconditionally
Message-ID: <20130626072102.GE1726@moon>
References: <0e00e9073855c02a382d49ba1ede9c4fda3451b7.1372189875.git.luto@amacapital.net>
 <20130625201602.GB1726@moon>
 <20130625201705.GA15966@redhat.com>
 <CALCETrVxm2wHvLgexG6fZO+h1rNHC_qDCv6B+4XuANHgSQU4iw@mail.gmail.com>
 <20130625215247.GC1726@moon>
 <CALCETrV2WZ3m82D4THfxvmASW8AOf1SN7Pu14vE0jMORupO5xw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALCETrV2WZ3m82D4THfxvmASW8AOf1SN7Pu14vE0jMORupO5xw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 25, 2013 at 03:01:35PM -0700, Andy Lutomirski wrote:
> 
> This is a little strange.  It looks like ppid (in status) shows the
> tgid, but the actual real_parent can refer to a thread (as opposed to
> a thread group leader), and task/tid/children respects that.  So the
> tree that you get by following task/tid/ children won't be quite the
> same as the tree you get by following ppid.
> 
> I wonder if the ptid should be added to status.  Is there anything
> (other than task/tid/children) that cased which thread is the parent
> of a given task?

None I know of. As to ptid -- sounds reasonable to me. Oleg?
