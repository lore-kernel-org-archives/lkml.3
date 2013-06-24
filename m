Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751891Ab3FXTfj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jun 2013 15:35:39 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:49412 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750900Ab3FXTfg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jun 2013 15:35:36 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Shuah Khan <shuah.kh@samsung.com>
Cc: Joe Perches <joe@perches.com>, "pavel@ucw.cz" <pavel@ucw.cz>,
        "len.brown@intel.com" <len.brown@intel.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "shuahkhan@gmail.com" <shuahkhan@gmail.com>
Subject: Re: [PATCHv v3] power: Include additional information in pm_print_times
Date: Mon, 24 Jun 2013 21:45:03 +0200
Message-ID: <3098328.kly7qFelcA@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.10.0-rc5+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <B8EFE96D1287C24090BAD9D858E15E6172F34D@sisaex02sj>
References: <1371497795-20084-1-git-send-email-shuah.kh@samsung.com> <B8EFE96D1287C24090BAD9D858E15E6172F2E7@sisaex02sj> <B8EFE96D1287C24090BAD9D858E15E6172F34D@sisaex02sj>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, June 24, 2013 04:37:28 PM Shuah Khan wrote:
> On 06/24/2013 10:25 AM, Shuah Khan wrote:
> > On 06/23/2013 03:49 PM, Rafael J. Wysocki wrote:
> >> On Sunday, June 23, 2013 04:34:17 AM Joe Perches wrote:
> >>> On Sun, 2013-06-23 at 13:36 +0200, Rafael J. Wysocki wrote:
> >>>> Please keep the existing format as is literally and append any
> >>>> new information to the end of the line.
> >>>
> >>> Hi Shuah.
> >>>
> >>> Perhaps the better long-term approach would be to add
> >>> a new tracepoint too.
> >>
> >> In fact, I would even prefer it if new tracepoints were added so that we
> >> could deprecate the dmesg messages at one point in the future.
> >>
> >> Thanks,
> >> Rafael
> >>
> >>
> >
> > Rafael/Joe,
> >
> > I can work on adding a tracepoint. Do you want to take the v2 patch in
> > the meantime?
> >
> 
> Rafael,
> 
> ok. Caught up with the entire thread. v2 patch uses dev_info() and hence 
> same concern about format change applies to that one as well.
> 
> Do you want to take the v1 patch that didn't change the format and just 
> added the additional information at the end?

Well, if you're going to work on the tracepoints, I'll rather not take this
at all.

Thanks,
Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
