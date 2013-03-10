Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752648Ab3CJOLw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Mar 2013 10:11:52 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:42157 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751361Ab3CJOLv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Mar 2013 10:11:51 -0400
MIME-Version: 1.0
In-Reply-To: <1362919707-20784-1-git-send-email-mihneadb@gmail.com>
References: <1362919707-20784-1-git-send-email-mihneadb@gmail.com>
Date: Sun, 10 Mar 2013 16:11:50 +0200
X-Google-Sender-Auth: tHyjcl_kem8PUOXHS1aF66gRHMI
Message-ID: <CAOJsxLGYPUKr88PpxHUwq7NJmJ6Rrip-T1KUq1Yb8ry2jLcwYQ@mail.gmail.com>
Subject: Re: [PATCH] bcm: don't cast kzalloc() return value
From: Pekka Enberg <penberg@kernel.org>
To: Mihnea Dobrescu-Balaur <mihneadb@gmail.com>
Cc: devel@driverdev.osuosl.org, gregkh@linuxfoundation.org,
        klmckinney1@gmail.com, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 10, 2013 at 2:48 PM, Mihnea Dobrescu-Balaur
<mihneadb@gmail.com> wrote:
> Signed-off-by: Mihnea Dobrescu-Balaur <mihneadb@gmail.com>

Reviewed-by: Pekka Enberg <penberg@kernel.org>
