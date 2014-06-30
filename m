Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757093AbaF3T7k (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 15:59:40 -0400
Received: from mail-pa0-f44.google.com ([209.85.220.44]:49825 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752349AbaF3T7i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 15:59:38 -0400
Date: Mon, 30 Jun 2014 12:59:35 -0700
From: Patrik Fimml <patrikf@chromium.org>
To: Dudley Du <dudl@cypress.com>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Alan Stern <stern@rowland.harvard.edu>,
        Benson Leung <bleung@google.com>, Lily Rui <lily@cypress.com>,
        Daniel Kurtz <djkurtz@google.com>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 0/14] input: cyapa: re-architecture driver to support
 multi-trackpads in one driver
Message-ID: <20140630195935.GA18256@google.com>
References: <CAEn7tidaRxbLwQti8joDgq48K2YCAVE3uG-q6ZR=jEWAgm2tPg@mail.gmail.com>
 <77BC725C9062764F874D79F51E1F1A8F4C902B3B@S04-MBX01-01.s04.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <77BC725C9062764F874D79F51E1F1A8F4C902B3B@S04-MBX01-01.s04.local>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dudley,

On Mon, Jun 30, 2014 at 05:43:06AM +0000, Dudley Du wrote:
> Attached are the patches files, I sent it firstly.

Thanks for the response, I was able to apply the patches now.

The attached files lack headers and commit messages though, so I don't have
fine-grained history in my git tree for convenient later review. The file names
suggest to me that you might just have copy-and-pasted the patches from
somewhere.

It would be great if you could attach them again in the format produced by "git
format-patch", with no further modifications done by hand. (If you feel the
need to do modifications, you should modify the actual commits e.g. with "git
rebase -i" before using format-patch.) Others can then simply import your
changes - including commit messages - into their tree with "git am".

Thanks,
Patrik
