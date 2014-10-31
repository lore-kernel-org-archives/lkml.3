Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755472AbaJaHmK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2014 03:42:10 -0400
Received: from s3.sipsolutions.net ([5.9.151.49]:50296 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751362AbaJaHmI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2014 03:42:08 -0400
Message-ID: <1414741319.3014.4.camel@jlt4.sipsolutions.net>
Subject: Re: [RFC v2 2/4] backports: replace BACKPORT_PWD with BACKPORT_DIR
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Cc: backports@vger.kernel.org, linux-kernel@vger.kernel.org,
        yann.morin.1998@free.fr, mmarek@suse.cz, sassmann@kpanic.de,
        "Luis R. Rodriguez" <mcgrof@suse.com>
Date: Fri, 31 Oct 2014 08:41:59 +0100
In-Reply-To: <1414570902-5675-3-git-send-email-mcgrof@do-not-panic.com> (sfid-20141029_092415_159248_4CCB658A)
References: <1414570902-5675-1-git-send-email-mcgrof@do-not-panic.com>
	 <1414570902-5675-3-git-send-email-mcgrof@do-not-panic.com>
	 (sfid-20141029_092415_159248_4CCB658A)
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.2-1+b1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-10-29 at 01:21 -0700, Luis R. Rodriguez wrote:
> From: "Luis R. Rodriguez" <mcgrof@suse.com>
> 
> This will also be used for built-in kernel integration, by
> using this we can share more code with the built-in kernel
> approach.

I see no issues with this, looks like a straight rename.

johannes

