Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755870AbaCETZs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 14:25:48 -0500
Received: from g4t3426.houston.hp.com ([15.201.208.54]:48431 "EHLO
	g4t3426.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751630AbaCETZr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 14:25:47 -0500
Message-ID: <1394047535.2512.83.camel@buesod1.americas.hpqcorp.net>
Subject: Re: [PATCH][v2] selftests: ipc: handle msgget failure return
 correctly
From: Davidlohr Bueso <davidlohr@hp.com>
To: Colin King <colin.king@canonical.com>
Cc: skinsbursky@parallels.com, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Date: Wed, 05 Mar 2014 11:25:35 -0800
In-Reply-To: <1394045908-9031-1-git-send-email-colin.king@canonical.com>
References: <1394045908-9031-1-git-send-email-colin.king@canonical.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-03-05 at 18:58 +0000, Colin King wrote:
> From: Colin Ian King <colin.king@canonical.com>
> 
> A failed msgget causes the test to return an uninitialised value
> in ret. Assign ret to -errno on error exit.
> 
> Signed-off-by: Colin Ian King <colin.king@canonical.com>

Why are you not carrying my ack??

Also, this needs to be CCed to Andrew.

