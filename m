Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754116AbaFPHVJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 03:21:09 -0400
Received: from cpsmtpb-ews08.kpnxchange.com ([213.75.39.13]:60552 "EHLO
	cpsmtpb-ews08.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752775AbaFPHVH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 03:21:07 -0400
Message-ID: <1402903265.17230.4.camel@x220>
Subject: Re: [uml-devel] [PATCH v2] delete unnecessary bootmem struct page
 array
From: Paul Bolle <pebolle@tiscali.nl>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Real Name <enjoymindful@gmail.com>, Richard Weinberger <richard@nod.at>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        uml-devel <user-mode-linux-devel@lists.sourceforge.net>
Date: Mon, 16 Jun 2014 09:21:05 +0200
In-Reply-To: <CAMuHMdV7gGFERHA-f_LcAeGFOvnx39kEhf+q5_QLz+buu3WWRA@mail.gmail.com>
References: <1401773445-25256-1-git-send-email-enjoymindful@gmail.com>
	 <539C1964.4050504@nod.at> <20140616032852.GA1763@name>
	 <CAMuHMdV7gGFERHA-f_LcAeGFOvnx39kEhf+q5_QLz+buu3WWRA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-2.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 16 Jun 2014 07:21:05.0704 (UTC) FILETIME=[894F3280:01CF8933]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-06-16 at 08:58 +0200, Geert Uytterhoeven wrote:
> On Mon, Jun 16, 2014 at 5:28 AM, Real Name <enjoymindful@gmail.com> wrote:
> > what is the pre-git linux tree? I searched it with google, but failed.
> 
> E.g. git.kernel.org/cgit/linux/kernel/git/tglx/history.git/

The archive at https://archive.org/details/git-history-of-linux seems to
be the most comprehensive. I use it regularly. It can even be made to
track the current tree. The tags for pre-v2.6.12-rc2 releases need to be
added manually, which is quite a bit of work.

Is there something better out there?


Paul Bolle

