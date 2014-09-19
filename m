Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932232AbaISSGn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2014 14:06:43 -0400
Received: from mx1.redhat.com ([209.132.183.28]:3095 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932117AbaISSGm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2014 14:06:42 -0400
Date: Fri, 19 Sep 2014 20:03:59 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Roman Peniaev <r.peniaev@gmail.com>
Cc: Ming Lei <ming.lei@canonical.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [v3 PATCH 1/1] init: fix race between rootfs mount and
	firmware loading
Message-ID: <20140919180359.GA4402@redhat.com>
References: <20140917174647.GC19308@redhat.com> <1411047228-2576-1-git-send-email-r.peniaev@gmail.com> <20140918174127.GB340@redhat.com> <CACZ9PQWDynSqUREO_79e5DFKqhV62ra3ecYYaNttOdNx4wS6_A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACZ9PQWDynSqUREO_79e5DFKqhV62ra3ecYYaNttOdNx4wS6_A@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/19, Roman Peniaev wrote:
>
> On Fri, Sep 19, 2014 at 2:41 AM, Oleg Nesterov <oleg@redhat.com> wrote:
> > On 09/18, Roman Pen wrote:
> >>
> >> +EXPORT_SYMBOL(wait_for_rootfs);
> >
> > Why?
>
> CONFIG_FW_LOADER (which includes firmware_class.c to compilation
> sequence) is declared as tristate,

Ah, I didn't know it can be compiled as a module. Thanks, you are
right.

Oleg.

