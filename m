Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755633Ab3ARUzk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2013 15:55:40 -0500
Received: from mail-bk0-f43.google.com ([209.85.214.43]:60286 "EHLO
	mail-bk0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752459Ab3ARUzi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2013 15:55:38 -0500
MIME-Version: 1.0
X-Originating-IP: [93.172.50.55]
In-Reply-To: <1358541741-20708-1-git-send-email-dinggnu@gmail.com>
References: <1358541741-20708-1-git-send-email-dinggnu@gmail.com>
From: Ohad Ben-Cohen <ohad@wizery.com>
Date: Fri, 18 Jan 2013 22:55:15 +0200
Message-ID: <CAK=WgbbW+Kje8fMNmSAy+qM6sLcoqZcLcev8w115BfGrQzHk2A@mail.gmail.com>
Subject: Re: [PATCH] iommu: omap-iommu.c: remove unnecessary null pointer check
To: Cong Ding <dinggnu@gmail.com>
Cc: Joerg Roedel <joro@8bytes.org>, Tony Lindgren <tony@atomide.com>,
        Omar Ramirez Luna <omar.luna@linaro.org>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 18, 2013 at 10:42 PM, Cong Ding <dinggnu@gmail.com> wrote:
> The pointer obj is dereferenced in line 146 and 149 respectively, so it is not
> necessary to check null again in line 149 and 175. And I have checked that all
> the callers of these two functions guarantee the parameter obj passed is not
> null.
>
> Signed-off-by: Cong Ding <dinggnu@gmail.com>

Acked-by: Ohad Ben-Cohen <ohad@wizery.com>
