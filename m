Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752361Ab3HFBAJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 21:00:09 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:54941 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751824Ab3HFBAI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 21:00:08 -0400
Message-ID: <1375750807.1968.20.camel@joe-AO722>
Subject: Re: [PATCH 1/1] checkpatch: fix some whitespace issues caused by
 --fix
From: Joe Perches <joe@perches.com>
To: Phil Carmody <phil.carmody@partner.samsung.com>
Cc: apw@canonical.com, linux-kernel@vger.kernel.org
Date: Mon, 05 Aug 2013 18:00:07 -0700
In-Reply-To: <1375700932-2851-1-git-send-email-phil.carmody@partner.samsung.com>
References: <1375700932-2851-1-git-send-email-phil.carmody@partner.samsung.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-08-05 at 14:08 +0300, Phil Carmody wrote:
> Lines with incorrect spacing around an operator, such as:
>   bystander, correct,incorrect
> would get "fixed" to
>   bystander,correct, incorrect
> as the correct argument as well as the incorrectly-spaced operator
> were both being trimmed. The correct argument only needs to be
> right trimmed.

Thanks for the patch, but I think it needs a different fix.

Even after your patch the --fix option still makes a mess
of several code spacing issues.

I'll work on it and propose something soonish.

