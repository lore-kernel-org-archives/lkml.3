Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753155AbaJPVTS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2014 17:19:18 -0400
Received: from mail-oi0-f41.google.com ([209.85.218.41]:49565 "EHLO
	mail-oi0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752781AbaJPVTQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2014 17:19:16 -0400
MIME-Version: 1.0
In-Reply-To: <20141016211136.GA27468@redhat.com>
References: <20141016203954.GA26336@redhat.com>
	<CAM_iQpUyCR3Bv1QhFkVmii9vB=fjMAUiWZ4T+mj60=FUZOXS+A@mail.gmail.com>
	<20141016211136.GA27468@redhat.com>
Date: Thu, 16 Oct 2014 14:19:16 -0700
Message-ID: <CAM_iQpXM6eUnvofOq0c71Nx3HygzriKKpN6Vc1+fY=dzFR08ig@mail.gmail.com>
Subject: Re: + freezer-check-oom-kill-while-being-frozen.patch added to -mm tree
From: Cong Wang <xiyou.wangcong@gmail.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Michal Hocko <mhocko@suse.cz>, David Rientjes <rientjes@google.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>, Tejun Heo <tj@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 16, 2014 at 2:11 PM, Oleg Nesterov <oleg@redhat.com> wrote:
>
> But also I can't understand why this patch helps. The changelog says:
>
>         do_send_sig_info will wake up the thread
>
> why?
>

This is a question for Michal who rewrites my changelog:

http://marc.info/?l=linux-kernel&m=140986986423092&w=2

:)
