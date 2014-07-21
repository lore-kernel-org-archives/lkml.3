Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754011AbaGUUVc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 16:21:32 -0400
Received: from mail-wg0-f43.google.com ([74.125.82.43]:37276 "EHLO
	mail-wg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750821AbaGUUVa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 16:21:30 -0400
From: Till Smejkal <till.smejkal@googlemail.com>
X-Google-Original-From: Till Smejkal <till.smejkal@gmail.com>
Date: Mon, 21 Jul 2014 22:21:26 +0200
To: linux-kernel@vger.kernel.org
Cc: linux-api@vger.kernel.org, linux-crypto@vger.kernel.org, beck@openbsd.org,
        deraadt@cvs.openbsd.org, "Theodore Ts'o" <tytso@mit.edu>
Subject: Re: [PATCH -v4] random: introduce getrandom(2) system call
Message-ID: <20140721202125.GF1158@osiris>
Mail-Followup-To: linux-kernel@vger.kernel.org, linux-api@vger.kernel.org,
	linux-crypto@vger.kernel.org, beck@openbsd.org,
	deraadt@cvs.openbsd.org, Theodore Ts'o <tytso@mit.edu>
References: <1405718127-30042-1-git-send-email-tytso@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1405718127-30042-1-git-send-email-tytso@mit.edu>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Fri, 18 Jul 2014, Theodore Ts'o wrote:
[...]
> 	If the GRND_RANDOM bit is not set, then the /dev/urandom pool
> 	will be used.  Unlike using read(2) to fetch data from
> 	/dev/urandom, if the urandom pool has not been sufficiently
> 	initialized, getrandom(2) will block or return -1 with the
> 	errno set to EGAIN if the GRND_NONBLOCK bit is set in flags.
                 ^^^^^
Small typo: this should be EAGAIN.

[...]

Regards

Till Smejkal
