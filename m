Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753355AbaCESNd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 13:13:33 -0500
Received: from g4t3425.houston.hp.com ([15.201.208.53]:25033 "EHLO
	g4t3425.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751951AbaCESNc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 13:13:32 -0500
Message-ID: <1394043210.2512.79.camel@buesod1.americas.hpqcorp.net>
Subject: Re: [PATCH] selftests: ipc: handle msgget failure return correctly
From: Davidlohr Bueso <davidlohr@hp.com>
To: Colin King <colin.king@canonical.com>
Cc: Stanislav Kinsbursky <skinsbursky@parallels.com>,
        linux-kernel@vger.kernel.org
Date: Wed, 05 Mar 2014 10:13:30 -0800
In-Reply-To: <1394041873-4220-1-git-send-email-colin.king@canonical.com>
References: <1394041873-4220-1-git-send-email-colin.king@canonical.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-03-05 at 17:51 +0000, Colin King wrote:
> From: Colin Ian King <colin.king@canonical.com>
> 
> A failed msgget causes the test to return an uninitialised value
> in ret. Assign ret to -errno on error exit.
> 
> Signed-off-by: Colin Ian King <colin.king@canonical.com>

Acked-by: Davidlohr Bueso <davidlohr@hp.com>

