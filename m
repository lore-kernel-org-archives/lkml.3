Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751735Ab3CRQNs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 12:13:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:15431 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751149Ab3CRQNr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 12:13:47 -0400
Date: Mon, 18 Mar 2013 09:13:42 -0700
From: Zach Brown <zab@redhat.com>
To: "Theodore Ts'o" <tytso@mit.edu>, Kent Overstreet <koverstreet@google.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, linux-aio@kvack.org
Subject: adding missed signed-off-by for aio retry removal patch
Message-ID: <20130318161342.GB2322@lenny.home.zabbo.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Fellas,

Kent mentioned that Ted was reviewing the aio patch series and wanted to
see a Signed-off-by: from me for the patch that tears out the retry
infrastructure.  I had left it out as the patch was changing as we
reviewed it and we forgot to add it in as it was finalized :(.

Ted, here's my sob for the version of the patch that's in -next via
Andrew's patches at this moment:

    commit ae5e0fe5ecafc6f8285367a20a8915b67a91066c
    Author: Zach Brown <zab@redhat.com>
    Date:   Thu Jan 24 13:14:37 2013 +1100

        aio: remove retry-based AIO

Signed-off-by: Zach Brown <zab@redhat.com>

Hopefully that's sufficient :)

- z
