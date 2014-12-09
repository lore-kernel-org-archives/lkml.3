Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751370AbaLIUeK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2014 15:34:10 -0500
Received: from mail-vc0-f171.google.com ([209.85.220.171]:52922 "EHLO
	mail-vc0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751211AbaLIUeH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2014 15:34:07 -0500
MIME-Version: 1.0
In-Reply-To: <7F8EB1E5A1A71643ACAD0928E03FFDE90E3D796C21@USMBX1.msg.corp.akamai.com>
References: <7F8EB1E5A1A71643ACAD0928E03FFDE90E3D796BF2@USMBX1.msg.corp.akamai.com>
	<20141209194602.GB20166@kroah.com>
	<CAKocOOMGoCtDjG24cJhkrJ=EyhbW-qy6=v5pJaRBeSPZuvZWfA@mail.gmail.com>
	<7F8EB1E5A1A71643ACAD0928E03FFDE90E3D796C21@USMBX1.msg.corp.akamai.com>
Date: Tue, 9 Dec 2014 13:34:06 -0700
Message-ID: <CAKocOOMiaUDaP=PJ7R9dtsg001eP68hNLyryVQV=yLMC92aeyg@mail.gmail.com>
Subject: Re: selftests: question about git repos containing selftest.
From: Shuah Khan <shuahkhan@gmail.com>
To: "Young, David" <dayoung@akamai.com>
Cc: Greg KH <gregkh@linuxfoundation.org>,
        "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>,
        "shuahkh@osg.samsung.com" <shuahkh@osg.samsung.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 9, 2014 at 1:25 PM, Young, David <dayoung@akamai.com> wrote:
> Thanks, I was definitely looking at the master branch of linux-kselftest.
>
> There are still more changes in linux-next repo, should those be considered as "in progress"?
>

Patches in linux-kselftest fixes branch are the ones I included in my
pull request
I just sent out. linux-next might have some selftest patches that are part of a
series that depend on a sub-system API. Maybe that is what you are seeing
in linux-next.

For example there are ftrace selftest patches in linux-next that
depend on ftrace
sub-system, hence they funnel through ftrace. Same thing happens with mm
related things.

Do you have specific patches in linux-next that you have questions about?

-- Shuah
