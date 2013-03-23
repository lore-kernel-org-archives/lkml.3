Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752602Ab3CWXf6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Mar 2013 19:35:58 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:37072 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752329Ab3CWXf5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Mar 2013 19:35:57 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Bob Moore <robert.moore@intel.com>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: pm/linux-next cause network stop working with qemu-kvm/e1000
Date: Sun, 24 Mar 2013 00:43:18 +0100
Message-ID: <1936124.cEBL1gZTc7@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.9.0-rc3+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <CAE9FiQWX15yH+7xgOZOg5XuLcoVEaJq3hononPkh5gYoC_C+zw@mail.gmail.com>
References: <CAE9FiQVZ5VZDo1KCun6SDonTJ=TGWLxm5zJQN5U4f1_52cKKwg@mail.gmail.com> <2281042.ltEMndsGee@vostro.rjw.lan> <CAE9FiQWX15yH+7xgOZOg5XuLcoVEaJq3hononPkh5gYoC_C+zw@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, March 23, 2013 09:18:55 AM Yinghai Lu wrote:
> On Sat, Mar 23, 2013 at 5:30 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> 
> >>
> >> Attached patch fix the problem. Please fold it into offending patch in
> >> pm/linux-next.
> >
> > I'd actually prefer to apply it as a separate patch, so can you please post
> > it with a proper changelog?
> 
> but that will break bisecting, right?

We need to keep ACPICA changes and Linux-specific modifications separate
for process-related reasons.

Thanks,
Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
