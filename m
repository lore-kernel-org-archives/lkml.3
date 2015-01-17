Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752274AbbAQQzE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Jan 2015 11:55:04 -0500
Received: from mail-qc0-f178.google.com ([209.85.216.178]:57476 "EHLO
	mail-qc0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750928AbbAQQzD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Jan 2015 11:55:03 -0500
MIME-Version: 1.0
In-Reply-To: <1421511231-14482-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
References: <1421511231-14482-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
Date: Sat, 17 Jan 2015 10:55:01 -0600
X-Google-Sender-Auth: tApAi4bASAkwnS6yJ27F7inE3Mc
Message-ID: <CAEUsAPaJcx-3uzH5e-wfYgicejdPt8R88hZ5X8K2gH4eXHVaVw@mail.gmail.com>
Subject: Re: [PATCH] tipc: link: Remove unused function
From: Chris Rorvick <chris@rorvick.com>
To: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
Cc: Jon Maloy <jon.maloy@ericsson.com>,
        Allan Stephens <allan.stephens@windriver.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        tipc-discussion@lists.sourceforge.net, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 17, 2015 at 10:13 AM, Rickard Strandqvist
<rickard_strandqvist@spectrumdigital.se> wrote:
> Remove the function tipc_link_get_max_pkt() that is not used anywhere.

This is already in the next tree:

commit 54fef04ad05f15984082c225fe47ce6af8ea1c5c
Author: Ying Xue <ying.xue@windriver.com>
Date:   Fri Jan 9 15:27:03 2015 +0800

    tipc: remove unused tipc_link_get_max_pkt routine

    Signed-off-by: Ying Xue <ying.xue@windriver.com>
    Tested-by: Tero Aho <Tero.Aho@coriant.com>
    Reviewed-by: Jon Maloy <jon.maloy@ericsson.com>
    Signed-off-by: David S. Miller <davem@davemloft.net>
