Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751778Ab3FWVtj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Jun 2013 17:49:39 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:48358 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751416Ab3FWVti (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Jun 2013 17:49:38 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Joe Perches <joe@perches.com>
Cc: Shuah Khan <shuah.kh@samsung.com>, "pavel@ucw.cz" <pavel@ucw.cz>,
        "len.brown@intel.com" <len.brown@intel.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "shuahkhan@gmail.com" <shuahkhan@gmail.com>
Subject: Re: [PATCHv v3] power: Include additional information in pm_print_times
Date: Sun, 23 Jun 2013 23:59:03 +0200
Message-ID: <7303551.DgZO2t6GUO@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.10.0-rc5+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <1371987257.3137.44.camel@joe-AO722>
References: <1371497795-20084-1-git-send-email-shuah.kh@samsung.com> <3043483.hQyzHovghE@vostro.rjw.lan> <1371987257.3137.44.camel@joe-AO722>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, June 23, 2013 04:34:17 AM Joe Perches wrote:
> On Sun, 2013-06-23 at 13:36 +0200, Rafael J. Wysocki wrote:
> > Please keep the existing format as is literally and append any
> > new information to the end of the line.
> 
> Hi Shuah.
> 
> Perhaps the better long-term approach would be to add
> a new tracepoint too.

In fact, I would even prefer it if new tracepoints were added so that we
could deprecate the dmesg messages at one point in the future.

Thanks,
Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
