Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751751AbaIEQny (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 12:43:54 -0400
Received: from mail-oa0-f51.google.com ([209.85.219.51]:59343 "EHLO
	mail-oa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750736AbaIEQnx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 12:43:53 -0400
MIME-Version: 1.0
In-Reply-To: <20140905140815.GA10455@mtj.dyndns.org>
References: <1409869842-10807-1-git-send-email-xiyou.wangcong@gmail.com>
	<20140905140815.GA10455@mtj.dyndns.org>
Date: Fri, 5 Sep 2014 09:43:52 -0700
Message-ID: <CAM_iQpXJfNAfTvfWNCUrdkwSWk7e2hkpoi4rba42RP7K=aYQDQ@mail.gmail.com>
Subject: Re: [Patch v4 1/2] freezer: check OOM kill while being frozen
From: Cong Wang <xiyou.wangcong@gmail.com>
To: Tejun Heo <tj@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, David Rientjes <rientjes@google.com>,
        Michal Hocko <mhocko@suse.cz>, "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 5, 2014 at 7:08 AM, Tejun Heo <tj@kernel.org> wrote:
>
> Prolly should stable@vger.kernel.org?

Oh, yes. I assume the maintainer (Michal?) will send it to stable
once it is accepted, or I can do that after it is merged.
