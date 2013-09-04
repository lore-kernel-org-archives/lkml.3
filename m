Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761966Ab3IDEzQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Sep 2013 00:55:16 -0400
Received: from mail-wg0-f46.google.com ([74.125.82.46]:38288 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761399Ab3IDEzO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Sep 2013 00:55:14 -0400
Date: Wed, 4 Sep 2013 07:55:07 +0300
From: Dan Aloni <alonid@stratoscale.com>
To: Dmitry Vyukov <dvyukov@google.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrey Konovalov <andreyknvl@google.com>,
        Kostya Serebryany <kcc@google.com>,
        Alexander Potapenko <glider@google.com>,
        Evgeniy Stepanov <eugenis@google.com>
Subject: Re: Potential use-after-free in ____call_usermodehelper
Message-ID: <20130904045506.GA12841@gmail.com>
References: <CACT4Y+ZLN+22hSKSQBbAc14cDi69gm9A+DK54K9hMa5VVi=mUw@mail.gmail.com>
 <CACT4Y+artcxiies1q3XP3+yCh+QzPZQ96dDttpdYXoQ+w2xosQ@mail.gmail.com>
 <CACT4Y+YobKoy9Yp5b6eM21oQrt+bj74qW6uM_DYPkeL-TVA3dQ@mail.gmail.com>
 <20130903202755.GA26033@gmail.com>
 <CACT4Y+YjAHgN2fvUsDZ2VZyBVmYacKZdwHJSCJXoHh_P=3dOaQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACT4Y+YjAHgN2fvUsDZ2VZyBVmYacKZdwHJSCJXoHh_P=3dOaQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 04, 2013 at 12:49:58AM +0400, Dmitry Vyukov wrote:
> On Wed, Sep 4, 2013 at 12:27 AM, Dan Aloni <alonid@stratoscale.com> wrote:
> > Your work and contribution is appreciated nonetheless, but your bug
> > report needs to pertain closer to the work the core kernel hackers
> > are doing.
> 
> What exactly do you mean?

The kernel hackers are more likely to look into the issue when it is based
on their development trees or stable tree. i.e the minimal 'git diff' from 
one of their versions is the smallest.

> Btw, is it better to report such things here or file on bugzilla.kernel.org?

See the REPORTING-BUGS file in the source tree.

-- 
Dan Aloni
