Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753171AbaLIVQe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2014 16:16:34 -0500
Received: from smtp2.provo.novell.com ([137.65.250.81]:41268 "EHLO
	smtp2.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751665AbaLIVOR (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:0:0>);
	Tue, 9 Dec 2014 16:14:17 -0500
X-Greylist: delayed 1209 seconds by postgrey-1.27 at vger.kernel.org; Tue, 09 Dec 2014 16:14:16 EST
Message-ID: <1418158435.10123.10.camel@stgolabs.net>
Subject: Re: selftests: question about git repos containing selftest.
From: Davidlohr Bueso <dave@stgolabs.net>
To: Shuah Khan <shuahkhan@gmail.com>
Cc: "Young, David" <dayoung@akamai.com>, Greg KH <gregkh@linuxfoundation.org>,
        "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>,
        "shuahkh@osg.samsung.com" <shuahkh@osg.samsung.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Tue, 09 Dec 2014 12:53:55 -0800
In-Reply-To: <CAKocOOMiaUDaP=PJ7R9dtsg001eP68hNLyryVQV=yLMC92aeyg@mail.gmail.com>
References: <7F8EB1E5A1A71643ACAD0928E03FFDE90E3D796BF2@USMBX1.msg.corp.akamai.com>
	 <20141209194602.GB20166@kroah.com>
	 <CAKocOOMGoCtDjG24cJhkrJ=EyhbW-qy6=v5pJaRBeSPZuvZWfA@mail.gmail.com>
	 <7F8EB1E5A1A71643ACAD0928E03FFDE90E3D796C21@USMBX1.msg.corp.akamai.com>
	 <CAKocOOMiaUDaP=PJ7R9dtsg001eP68hNLyryVQV=yLMC92aeyg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.7 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-12-09 at 13:34 -0700, Shuah Khan wrote:
> On Tue, Dec 9, 2014 at 1:25 PM, Young, David <dayoung@akamai.com> wrote:
> > Thanks, I was definitely looking at the master branch of linux-kselftest.
> >
> > There are still more changes in linux-next repo, should those be considered as "in progress"?
> >
> 
> Patches in linux-kselftest fixes branch are the ones I included in my
> pull request
> I just sent out. linux-next might have some selftest patches that are part of a
> series that depend on a sub-system API. Maybe that is what you are seeing
> in linux-next.

Is there any reason why Andrew isn't handling kselftests? Considering it
spans multiple subsystems, it seems far more appropriate that way.

