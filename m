Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755297Ab3JITMp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Oct 2013 15:12:45 -0400
Received: from a9-62.smtp-out.amazonses.com ([54.240.9.62]:35661 "EHLO
	a9-62.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754491Ab3JITMo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Oct 2013 15:12:44 -0400
Date: Wed, 9 Oct 2013 19:07:52 +0000
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Tim Bird <tim.bird@sonymobile.com>
cc: catalin.marinas@arm.com, frowand.list@gmail.com,
        bjorn.andersson@sonymobile.com, tbird20d@gmail.com, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        Roman Bobniev <Roman.Bobniev@sonymobile.com>,
        Pekka Enberg <penberg@kernel.org>
Subject: Re: [PATCH] slub: proper kmemleak tracking if CONFIG_SLUB_DEBUG
 disabled
In-Reply-To: <1381273137-14680-1-git-send-email-tim.bird@sonymobile.com>
Message-ID: <000001419e9e3e33-67807dca-e435-43ee-88bc-3ead54a83762-000000@email.amazonses.com>
References: <1381273137-14680-1-git-send-email-tim.bird@sonymobile.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-SES-Outgoing: 2013.10.09-54.240.9.62
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 8 Oct 2013, Tim Bird wrote:

> It also fixes a bug where kmemleak was only partially enabled in some
> configurations.

Acked-by: Christoph Lameter <cl@linux.com>

